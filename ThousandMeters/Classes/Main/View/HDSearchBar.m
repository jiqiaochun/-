//
//  HDSearchBar.m
//  微博
//
//  Created by ji on 15/8/5.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "HDSearchBar.h"

@interface HDSearchBar ()

@end

@implementation HDSearchBar

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"请输入关键字";
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        
        // 设置左边的放大镜图标
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        searchIcon.width = 30;
        searchIcon.height = 30;
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

+ (instancetype)searchBar{
    return [[HDSearchBar alloc] init];
}


@end
