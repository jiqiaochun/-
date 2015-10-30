//
//  UIImageBannerScrollView.h
//  UIImageBannerScrollView
//
//  Created by likai on 15/7/15.
//  Copyright (c) 2015年 likai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIImageBannerScrollView;
@protocol BannerScrollViewDelegate <NSObject>

@optional
- (void)scrollViewClicked:(UIImageBannerScrollView *)bannerView didSelectIndex:(NSInteger)index withUrlString:(NSString *)urlString;

@end

//分页符的位置
typedef NS_ENUM(NSInteger, BannerViewPageControlStyle) {
    PageControlAlignRightTop,       //右上
    PageControlAlignLeftBottom,     //左下
    PageControlAlignRightBottom,    //右下
    PageControlAlignMiddleBottom    //中下(默认)
};

@interface UIImageBannerScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) id <BannerScrollViewDelegate> scrollDelegate;

/**是否自动轮播(默认开启)*/
@property (nonatomic, assign) BOOL bannerAutoScroll;

/**滚动间隔时间(默认5s)*/
@property (nonatomic, assign) NSTimeInterval bannerScrollTimer;

/**是否需要显示顶部灰色阴影(参考苏宁、京东、途牛等顶部阴影)*/
@property (nonatomic, assign) BOOL isNeedTopGrayShadow;

/**初始化滚动视图*/
- (id)initWithFrame:(CGRect)frame images:(NSArray *)images;

/**开始滚动*/
- (void)startScrolling;

/**停止滚动*/
- (void)stopScrolling;

/**刷新视图*/
- (void)reloadBannerView:(NSArray *)images;

/**设置分页符显示位置(默认下中)*/
- (void)setPageControlAlignStyle:(BannerViewPageControlStyle)pageControlStyle;

@end
