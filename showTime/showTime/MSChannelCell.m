//
//  MSChannelCell.m
//  showTime
//
//  Created by msj on 2017/2/4.
//  Copyright © 2017年 msj. All rights reserved.
//

#import "MSChannelCell.h"

@interface MSChannelCell ()
@property (strong, nonatomic) UILabel *lbTips;
@end

@implementation MSChannelCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.lbTips = [[UILabel alloc] init];
        self.lbTips.font = [UIFont systemFontOfSize:15];
        self.lbTips.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.lbTips];
    }
    return self;
}

- (void)setModel:(MSChanneiModel *)model
{
    self.lbTips.text = model.title;
    self.lbTips.textColor = model.isSelected ? [UIColor redColor] : [UIColor blackColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.lbTips.frame = self.bounds;
}


@end
