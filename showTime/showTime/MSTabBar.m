//
//  MSTabBar.m
//  showTime
//
//  Created by msj on 2017/3/13.
//  Copyright © 2017年 msj. All rights reserved.
//

#import "MSTabBar.h"

@implementation MSTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    for (UIView *button in self.subviews) {
        
        if ([button isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            button.backgroundColor = [UIColor orangeColor];
        }
        
    }
}

@end
