//
//  UIBarButtonItem+Extension.m
//
//
//  Created by ji on 15/8/5.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

/**
 *  创建一个item
 *
 *  @param target      点击item后调用哪个对象的方法
 *  @param sel         点击item后调用的方法
 *  @param imageNormal 图片
 *  @param imageHlight 高亮的图片
 *
 *  @return <#return value description#>
 */
+ (instancetype)itemWithTarget:(id)target Action:(SEL)sel imageNormal:(NSString *)imageNormal imageHlight:(NSString *)imageHlight
{
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    // 添加点击事件
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    //设置图片
    [btn setBackgroundImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:imageHlight] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target Action:(SEL)sel{
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 添加点击事件
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    //设置文字
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    // 设置尺寸
    [btn sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
