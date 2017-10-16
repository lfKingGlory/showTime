//
//  MSScanSurfaceView.m
//  showTime
//
//  Created by msj on 16/9/27.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSScanSurfaceView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIColor+StringColor.h"
#define left_width (self.frame.size.width*3.0/16.0)

#define sacnRect_width (self.frame.size.width*10.0/16.0)
#define sacnRect_height (self.frame.size.width*10.0/16.0)

#define top_height ((self.frame.size.height-sacnRect_height)/2-60)
#define bottom_height (self.frame.size.height - top_height - sacnRect_height)

#define back_color [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]

#define yellow_line_length 18
#define yellow_line_stroke 3

@interface MSScanSurfaceView ()
@property (strong, nonatomic) UIButton *btnFlashlight;
@end

@implementation MSScanSurfaceView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scanRect = CGRectMake(left_width, top_height, sacnRect_width, sacnRect_height);
        isAnimation = YES;
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, top_height)];
        topView.backgroundColor = back_color;
        [self addSubview:topView];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, [self getY:topView], left_width, sacnRect_height)];
        leftView.backgroundColor = back_color;
        [self addSubview:leftView];
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-left_width, [self getY:topView], left_width, sacnRect_height)];
        rightView.backgroundColor = back_color;
        [self addSubview:rightView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [self getY:leftView], self.frame.size.width, bottom_height)];
        bottomView.backgroundColor = back_color;
        [self addSubview:bottomView];
        
        UIView *boardView = [[UIView alloc] initWithFrame:self.scanRect];
        boardView.backgroundColor = [UIColor clearColor];
        boardView.layer.borderColor = [[UIColor whiteColor] CGColor];
        boardView.layer.borderWidth = 1.0;
        [self addSubview:boardView];
        
        //左上角
        [self createYellowHLineWithX:left_width withY:top_height];
        [self createYellowVLineWithX:left_width withY:top_height];
        
        //右上角
        [self createYellowHLineWithX:self.frame.size.width-left_width-yellow_line_length withY:top_height];
        [self createYellowVLineWithX:self.frame.size.width-left_width-yellow_line_stroke withY:top_height];
        
        //左下角
        [self createYellowHLineWithX:left_width withY:top_height+sacnRect_height-yellow_line_stroke];
        [self createYellowVLineWithX:left_width withY:top_height+sacnRect_height-yellow_line_length];
        
        //右下角
        [self createYellowHLineWithX:self.frame.size.width-left_width-yellow_line_length withY:top_height+sacnRect_height-yellow_line_stroke];
        [self createYellowVLineWithX:self.frame.size.width-left_width-yellow_line_stroke withY:top_height+sacnRect_height-yellow_line_length];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.frame.size.width-20, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Heiti SC" size:12];
        label.textColor = [UIColor whiteColor];
        label.text = @"将二维码/条码放入框内，即可自动扫描";
        [bottomView addSubview:label];
        
        self.btnFlashlight = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) + 10, self.frame.size.width, 20)];
        [self.btnFlashlight setTitle:@"手电筒" forState:UIControlStateNormal];
        [self.btnFlashlight addTarget:self action:@selector(flashlight) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:self.btnFlashlight];
        
        baselineLayer = [[CALayer alloc]init];
        [baselineLayer setBounds:CGRectMake(left_width, top_height, sacnRect_width, 2)];
        [baselineLayer setBackgroundColor:[[UIColor redColor] CGColor]];
        
    }
    return self;
}

- (void)flashlight
{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if (device.torchMode == AVCaptureTorchModeOff) {
        [device setTorchMode:AVCaptureTorchModeOn];
    }else if(device.torchMode == AVCaptureTorchModeOn){
        [device setTorchMode:AVCaptureTorchModeOff];
    }
    [device unlockForConfiguration];
}

-(void)createYellowHLineWithX:(float)X withY:(float)Y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(X, Y, yellow_line_length, yellow_line_stroke)];
    line.backgroundColor = [UIColor yellowColor];
    [self addSubview:line];
}

-(void)createYellowVLineWithX:(float)X withY:(float)Y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(X, Y, yellow_line_stroke, yellow_line_length)];
    line.backgroundColor = [UIColor yellowColor];
    [self addSubview:line];
}

-(void)startBaseLineAnimation
{
    if (!baselineLayer.superlayer) {
        [self.layer addSublayer:baselineLayer];
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    [animation setFromValue:[NSValue valueWithCGPoint:CGPointMake(left_width+sacnRect_width/2, top_height)]];
    [animation setToValue:[NSValue valueWithCGPoint:CGPointMake(left_width+sacnRect_width/2, top_height+sacnRect_height)]];
    [animation setDuration:2];
    [baselineLayer addAnimation:animation forKey:nil];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (isAnimation) {
        [self startBaseLineAnimation];
    }else{
        [baselineLayer removeFromSuperlayer];
        isAnimation = YES;
    }
}

-(void)stopBaseLineAnimation
{
    isAnimation = NO;
}

-(float)getY:(UIView *)upView
{
    return upView.frame.origin.y+upView.frame.size.height;
}
@end
