//
//  MSScanSurfaceView.m
//  showTime
//
//  Created by msj on 16/9/27.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSScanSurfaceView.h"
#import <AVFoundation/AVFoundation.h>

#define screen_Height            [UIScreen mainScreen].bounds.size.height
#define screen_Width             [UIScreen mainScreen].bounds.size.width
#define sacnRect_width           (screen_Width * 10.0 / 16.0)
#define sacnRect_height          sacnRect_width
#define sacnRect_x               (screen_Width - sacnRect_width) / 2
#define sacnRect_y               (screen_Height - sacnRect_height) / 2
#define back_color               [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]

@interface MSScanSurfaceView ()
@property (strong, nonatomic) UIImageView *cornersImageView;
@property (strong, nonatomic) CALayer *scanImageView;
@end

@implementation MSScanSurfaceView

#pragma mark - Public
- (void)startAnimation {
    CAAnimation *animation = [self.scanImageView animationForKey:@"ms_scan"];
    if (animation) {
        return;
    }
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(CGRectGetHeight(self.cornersImageView.frame));
    basicAnimation.duration = 1.6;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[basicAnimation];
    group.repeatCount = CGFLOAT_MAX;
    group.duration = 1.8;
    [self.scanImageView addAnimation:group forKey:@"ms_scan"];
}

- (void)stopAnimation {
    CAAnimation *animation = [self.scanImageView animationForKey:@"ms_scan"];
    if (animation) {
        [self.scanImageView removeAnimationForKey:@"ms_scan"];
    }
}

#pragma mark - Pravite
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    
    _scanRect = CGRectMake(sacnRect_y / screen_Height, sacnRect_x / screen_Width, sacnRect_height / screen_Height, sacnRect_width / screen_Width);
    
    self.cornersImageView = [[UIImageView alloc] initWithFrame:CGRectMake(sacnRect_x, sacnRect_y, sacnRect_width, sacnRect_height)];
    self.cornersImageView.backgroundColor = [UIColor clearColor];
    self.cornersImageView.image = [UIImage imageNamed:@"baidu_rim_ocr_corners"];
    self.cornersImageView.layer.masksToBounds = YES;
    [self addSubview:self.cornersImageView];
    
    self.scanImageView = [CALayer layer];
    self.scanImageView.frame = CGRectMake(0, -CGRectGetHeight(self.cornersImageView.frame), CGRectGetWidth(self.cornersImageView.frame), CGRectGetHeight(self.cornersImageView.frame));
    self.scanImageView.backgroundColor = [UIColor clearColor].CGColor;
    UIImage *scanImage = [UIImage imageNamed:@"baidu_rim_ocr_animationImg"];
    self.scanImageView.contents = (id)scanImage.CGImage;
    [self.cornersImageView.layer addSublayer:self.scanImageView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, sacnRect_y)];
    topView.backgroundColor = back_color;
    [self addSubview:topView];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, sacnRect_y, sacnRect_x, sacnRect_height)];
    leftView.backgroundColor = back_color;
    [self addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cornersImageView.frame), sacnRect_y, sacnRect_x, sacnRect_height)];
    rightView.backgroundColor = back_color;
    [self addSubview:rightView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cornersImageView.frame), screen_Width, sacnRect_y)];
    bottomView.backgroundColor = back_color;
    [self addSubview:bottomView];
    
    UILabel *lbTips = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, screen_Width, 30)];
    lbTips.textAlignment = NSTextAlignmentCenter;
    lbTips.font = [UIFont fontWithName:@"Heiti SC" size:13];
    lbTips.textColor = [UIColor whiteColor];
    lbTips.text = @"将二维码放入框内，即可自动扫描";
    [bottomView addSubview:lbTips];

}
@end
