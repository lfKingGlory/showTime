//
//  MSWaterRipple.h
//  showTime
//
//  Created by msj on 16/8/22.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSWaterRipple : UIView

@property (assign, nonatomic) CGFloat waterTime;  
@property (assign, nonatomic) CGFloat waterSpeed;
@property (assign, nonatomic) CGFloat waterAngularVelocity;
@property (strong, nonatomic) UIColor *waterColor;

- (void)startAnimation;
- (void)stopAnimation;

- (instancetype)init __attribute__((unavailable("init不可用，请使用initWithFrame:")));
+ (instancetype)new __attribute__((unavailable("new不可用，请使用initWithFrame:")));
@end
