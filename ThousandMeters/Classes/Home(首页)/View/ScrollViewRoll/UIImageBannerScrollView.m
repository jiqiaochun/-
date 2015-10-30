//
//  UIImageBannerScrollView.m
//  UIImageBannerScrollView
//
//  Created by likai on 15/7/15.
//  Copyright (c) 2015年 likai. All rights reserved.
//

#import "UIImageBannerScrollView.h"
#import "UIImageView+WebCache.h"

#define BannerBeginTag     100

@interface UIImageBannerScrollView ()
{
    /**要显示的图片数组*/
    NSMutableArray      *imageArray;
    /**定时器*/
    NSTimer             *scrollTimmer;
    /**当前显示*/
    NSInteger           selectedIndex;
    
    /**顶部灰色阴影*/
    UIImageView         *topGrayShadow;
    /**placeholderImage*/
    UIImage             *placeholderImage;
    /**支持最大轮播个数(默认8个)*/
    NSInteger           bannerMaxItemCount;
    
    UIScrollView        *bannerScrollView;
    UIPageControl       *bannerPageControl;
    
}

@end

@implementation UIImageBannerScrollView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.clipsToBounds = YES;
        
        //设置默认值
        self.bannerAutoScroll = YES;
        self.bannerScrollTimer = 2.f;
        bannerMaxItemCount = 8;
        selectedIndex = 0;//默认显示第一张
        placeholderImage = [UIImage imageNamed:@"placeholder"];
        
        //根据最大显示个数调整数组
        [self adjustImagesArrayAccordingMaxAccount:images];
        
        //backgroundImageView(相当于placeholderImage)
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundImageView.image = placeholderImage;
        [self addSubview:backgroundImageView];
        
        //scrollView
        bannerScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        bannerScrollView.backgroundColor = [UIColor clearColor];
        bannerScrollView.showsHorizontalScrollIndicator = NO;
        bannerScrollView.showsVerticalScrollIndicator = NO;
        bannerScrollView.pagingEnabled = YES;
        bannerScrollView.scrollsToTop = NO;
        bannerScrollView.delegate = self;
        bannerScrollView.contentSize = CGSizeMake(bannerScrollView.frame.size.width * 3, bannerScrollView.frame.size.height);
        [self addSubview:bannerScrollView];
        
        //pageControl
        bannerPageControl = [[UIPageControl alloc] init];
        bannerPageControl.currentPageIndicatorTintColor = [UIColor redColor];
        bannerPageControl.pageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        bannerPageControl.numberOfPages = [imageArray count];
        bannerPageControl.currentPage = selectedIndex;
        [self addSubview:bannerPageControl];
        //设置默认分页符
        [self setPageControlAlignStyle:PageControlAlignMiddleBottom];
        
        //为了通用做法,始终创建3个ImageView,每次更换ImageView的image而不是每次都移除ImageView重新创建，有效减少cpu损耗
        for (NSInteger i = 0; i < 3; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setClipsToBounds:YES];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            imageView.userInteractionEnabled = YES;
            imageView.tag = BannerBeginTag + i;
            //点击事件
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:singleTap];
            //frame
            imageView.frame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height);
            [bannerScrollView addSubview:imageView];
        }
        
        //顶部灰色阴影
        topGrayShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        topGrayShadow.image = [UIImage imageNamed:@"icon_banner_topgray_shadow"];
        topGrayShadow.hidden = YES;
        [self addSubview:topGrayShadow];
    }
    return self;
}

#pragma mark - LifeCycle

- (void)dealloc {
    [scrollTimmer invalidate];
    scrollTimmer = nil;
}

#pragma mark - CustomMethods

//入口（此处作各种前提判断）
- (void)startScrolling {
    //数组不为空
    if (imageArray && [imageArray count] != 0) {
        //加载内容
        [self refreshScrollView];
        
        //仅当开启自动轮播且数组个数大于1
        if (self.bannerAutoScroll && [imageArray count] > 1) {
            [self startTimmer];
        }
        
        //分页符是否显示
        if ([imageArray count] > 1) {
            bannerPageControl.hidden = NO;
        } else {
            bannerPageControl.hidden = YES;
        }
        //是否显示顶部灰色阴影
        topGrayShadow.hidden = !self.isNeedTopGrayShadow;
    }
}

- (void)stopScrolling {
    [self stopTimmer];
}

- (void)reloadBannerView:(NSArray *)images {
    [self stopScrolling];
    selectedIndex = 0;
    //根据最大显示个数调整数组
    [self adjustImagesArrayAccordingMaxAccount:images];
    bannerPageControl.numberOfPages = imageArray.count;
    bannerPageControl.currentPage = selectedIndex;
    [self startScrolling];
}

//更新内容
- (void)refreshScrollView {
    //explain:为何在startScrolling中已经做了判断这里还要判断，因为在手动触发scrollViewDidScroll时，传入空数组会导致下面的数组越界
    if (imageArray && [imageArray count] != 0) {
        NSArray *displayArray = [self getDisplayArrayWithCurrentPageIndex:selectedIndex];
        for (NSInteger i = 0; i < 3; i ++) {
            UIImageView *imageView = (UIImageView *)[bannerScrollView viewWithTag:BannerBeginTag + i];
            NSString *url = displayArray[i];
            if (imageView && [imageView isKindOfClass:[UIImageView class]] && url.length > 0) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage];
            }
        }
        bannerScrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
}

//根据最大显示个数处理入参
- (NSArray *)adjustImagesArrayAccordingMaxAccount:(NSArray *)images {
    if (bannerMaxItemCount == 0) {
        //不允许出现0个
        bannerMaxItemCount = 1;
    }
    imageArray = [NSMutableArray arrayWithCapacity:0];
    if (images && [images count] > 0) {
        if ([images count] > bannerMaxItemCount) {
            [imageArray addObjectsFromArray:[images subarrayWithRange:NSMakeRange(0, bannerMaxItemCount)]];
        } else {
            [imageArray addObjectsFromArray:images];
        }
    }
    return imageArray;
}

- (NSArray *)getDisplayArrayWithCurrentPageIndex:(NSInteger)page {
    NSMutableArray *scrollDataArray = [NSMutableArray arrayWithCapacity:0];
    [scrollDataArray addObject:[imageArray objectAtIndex:[self getPrePage]]];
    [scrollDataArray addObject:[imageArray objectAtIndex:selectedIndex]];
    [scrollDataArray addObject:[imageArray objectAtIndex:[self getNextPage]]];
    return scrollDataArray;
}

- (NSInteger)getPrePage {
    NSInteger result = 0;
    if (selectedIndex == 0) {
        result = [imageArray count] - 1;
    } else {
        result = selectedIndex - 1;
    }
    return result;
}

- (NSInteger)getNextPage {
    NSInteger result = 0;
    if ((selectedIndex + 1) >= [imageArray count]) {
        result = 0;
    } else {
        result = selectedIndex + 1;
    }
    return result;
}

- (void)changeImages {
    selectedIndex ++;
    selectedIndex = selectedIndex % [imageArray count];
    
    //动画切换
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [bannerScrollView.layer addAnimation:animation forKey:nil];
    
    [self refreshScrollView];
    [bannerPageControl setCurrentPage:selectedIndex];
}

#pragma mark - Delegate Method

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if ([_scrollDelegate respondsToSelector:@selector(scrollViewClicked:didSelectIndex:withUrlString:)]) {
        [_scrollDelegate scrollViewClicked:self didSelectIndex:selectedIndex withUrlString:imageArray[selectedIndex]];
    }
}

#pragma mark - UI_CustomMethods

- (void)setPageControlAlignStyle:(BannerViewPageControlStyle)pageControlStyle {
    if (pageControlStyle == PageControlAlignRightTop) {
        //右上对齐
        bannerPageControl.frame = CGRectMake(self.frame.size.width/2, 25, self.frame.size.width/2, 3);
    } else if (pageControlStyle == PageControlAlignLeftBottom) {
        //左下
        bannerPageControl.frame = CGRectMake(0, self.frame.size.height - 12, self.frame.size.width/2, 3);
    } else if (pageControlStyle == PageControlAlignRightBottom) {
        //右下
        bannerPageControl.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height - 12, self.frame.size.width/2, 3);
    } else if (pageControlStyle == PageControlAlignMiddleBottom) {
        //中下
        bannerPageControl.frame = CGRectMake(0, self.frame.size.height - 12, self.frame.size.width, 3);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger xOffset = scrollView.contentOffset.x;
    if ((xOffset % (NSInteger)self.frame.size.width == 0)) {
        [bannerPageControl setCurrentPage:selectedIndex];
    }
    //往下翻一张
    if(xOffset >= (2*self.frame.size.width)) {
        //右
        selectedIndex++;
        selectedIndex = selectedIndex % [imageArray count];
        [self refreshScrollView];
    }
    if(xOffset <= 0) {
        //左
        if (selectedIndex == 0) {
            selectedIndex = (NSInteger)[imageArray count] - 1;
        } else {
            selectedIndex--;
        }
        [self refreshScrollView];
    }
}

//拖动开始，停止计时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimmer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    [bannerScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //开启定时器
    if (self.bannerAutoScroll && [imageArray count] > 1) {
        [self startTimmer];
    }
}

#pragma mark - Timer

- (void)startTimmer {
    scrollTimmer = [NSTimer scheduledTimerWithTimeInterval:self.bannerScrollTimer
                                                   target:self
                                                 selector:@selector(changeImages)
                                                 userInfo:nil
                                                  repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:scrollTimmer forMode:NSRunLoopCommonModes];
}

- (void)stopTimmer {
    [scrollTimmer invalidate];
    scrollTimmer = nil;
}

@end
