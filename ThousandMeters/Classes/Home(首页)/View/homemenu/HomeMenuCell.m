//
//  HomeMenuCell.m
//  meituan
//
//  Created by jinzelu on 15/6/30.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "HomeMenuCell.h"

@interface HomeMenuCell ()
{
    UIView *_backView;
}

@end

@implementation HomeMenuCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 160)];
        [self addSubview:_backView];
        
        //创建8个
        for (int i = 0; i < 8; i++) {
            if (i < 4) {
                CGRect frame = CGRectMake(i*kWidth/4, 0, kWidth/4, 80);
                NSString *title = [menuArray[i] objectForKey:@"title"];
                NSString *imageStr = [menuArray[i] objectForKey:@"image"];
                JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag = 10+i;
                [_backView addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
                
            }else {
                CGRect frame = CGRectMake((i-4)*kWidth/4, 80, kWidth/4, 80);
                NSString *title = [menuArray[i] objectForKey:@"title"];
                NSString *imageStr = [menuArray[i] objectForKey:@"image"];
                JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag = 10+i;
                [_backView addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
            }
        }
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)OnTapBtnView:(UITapGestureRecognizer *)sender{
    NSLog(@"tag:%ld",sender.view.tag);
}

@end
