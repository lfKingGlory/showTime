//
//  MSPageStateView.m
//  showTime
//
//  Created by msj on 2017/5/15.
//  Copyright © 2017年 msj. All rights reserved.
//

#import "MSPageStateView.h"
@implementation MSPageStateView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)showInView:(UIView *)superView {
    if (!superView || ![superView isKindOfClass:[UIView class]]) {
        return;
    }
    
    [superView addSubview:self];
    
}

- (void)dismiss {
    [self removeFromSuperview];
}
@end
