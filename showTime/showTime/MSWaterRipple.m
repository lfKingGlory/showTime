//
//  MSWaterRipple.m
//  showTime
//
//  Created by msj on 16/8/22.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSWaterRipple.h"

@interface MSWaterRipple ()
@property (assign, nonatomic) CGFloat offsetX;
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (strong, nonatomic) CAShapeLayer *waterLayer;

@end

@implementation MSWaterRipple

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _waterTime = 1;
    self.backgroundColor = [UIColor clearColor];
    _waterColor = [UIColor whiteColor];
    _waterSpeed = 9;
    _waterAngularVelocity = 2;
    _offsetX = 0;
}

- (void)startAnimation
{
    if (self.waterLayer.path) {
        return;
    }
    self.waterLayer = [CAShapeLayer layer];
    [self.waterLayer setFillColor:self.waterColor.CGColor];
    [self.layer addSublayer:self.waterLayer];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refresh)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    if (self.waterTime > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.waterTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopAnimation];
        });
    }
}

-(void)refresh
{
    self.offsetX -= self.waterSpeed;
    UIBezierPath *waterPath = [UIBezierPath bezierPath];
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    CGFloat y = 0;
    [waterPath moveToPoint:CGPointMake(0, height/2.0)];
    for (CGFloat x = 1; x <= self.frame.size.width; x++) {
        y = height * sin(0.01 * (self.waterAngularVelocity * x + self.offsetX));
        [waterPath addLineToPoint:CGPointMake(x, y)];
    }

    [waterPath addLineToPoint:CGPointMake(width, height)];
    [waterPath addLineToPoint:CGPointMake(0, height)];
    
    [waterPath closePath];
    self.waterLayer.path = waterPath.CGPath;
}

- (void)stopAnimation
{
   [UIView animateWithDuration:1.0 animations:^{
       self.alpha = 0;
   } completion:^(BOOL finished) {
       [self.displayLink invalidate];
       self.displayLink = nil;
       self.waterLayer.path = nil;
       self.alpha = 1;
   }];
}

@end
