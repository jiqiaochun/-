//
//  UIBarButtonItem+Extension.h
//  微博
//
//  Created by ji on 15/8/5.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (instancetype)itemWithTarget:(id)target Action:(SEL)sel imageNormal:(NSString *)imageNormal imageHlight:(NSString *)imageHlight;

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target Action:(SEL)sel;

@end
