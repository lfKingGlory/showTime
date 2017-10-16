//
//  MSCountDownView.h
//  showTime
//
//  Created by msj on 2016/12/20.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MSCountDownViewMode) {
    MSCountDownViewModeNormal,
    MSCountDownViewModeIntermediate,
    MSCountDownViewModeCountDown
};

@interface MSCountDownView : UIView
@property (assign, nonatomic) MSCountDownViewMode  currentMode;
@property (copy, nonatomic) void (^willBeginCountdown)(void);
@property (copy, nonatomic) void (^didEndCountdown)(void);
- (void)invalidate;
- (instancetype)init __attribute__((unavailable("init不可用，请使用initWithFrame:")));
+ (instancetype)new __attribute__((unavailable("new不可用，请使用initWithFrame:")));
@end



