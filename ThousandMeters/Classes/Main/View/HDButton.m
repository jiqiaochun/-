//
//  HDButton.m
//  ThousandMeters
//
//  Created by 虎动 on 15/10/29.
//  Copyright © 2015年 虎动. All rights reserved.
//

#import "HDButton.h"
#define Margin 5

@implementation HDButton

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.x = 0;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 5;
    self.width = self.titleLabel.width + self.imageView.width + Margin;
    //self.centerX = self.superview.width * 0.5;
}

//- (void)setTitle:(NSString *)title forState:(UIControlState)state{
//    [super setTitle:title forState:state];
//    
//    [self sizeToFit];
//}
//
//- (void)setImage:(UIImage *)image forState:(UIControlState)state{
//    [super setImage:image forState:state];
//    
//    [self sizeToFit];
//}


@end
