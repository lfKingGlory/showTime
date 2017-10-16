//
//  MSProgressView.m
//  showTime
//
//  Created by msj on 16/8/24.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSProgressView.h"

#define RGB(r,g,b)  [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1];
#define CG_RGB(r,g,b)  [[UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1] CGColor];
#define DEFAULTWIDTH   27

@interface MSProgressView ()
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) UILabel *lbPercent;
@end

@implementation MSProgressView
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
    self.backgroundColor = RGB(233, 233, 233);
    
    self.gradientLayer = [CAGradientLayer layer];
    UIColor *firstColor = RGB(117, 196, 242);
    UIColor *secondColor = RGB(96, 143, 228);
    self.gradientLayer.colors = @[(id)firstColor.CGColor,(id)secondColor.CGColor];
    self.gradientLayer.locations = @[@0.3];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5);
    [self.layer addSublayer:self.gradientLayer];
    
    self.lbPercent = [[UILabel alloc] init];
    self.lbPercent.font = [UIFont systemFontOfSize:10];
    self.lbPercent.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lbPercent];
}

- (void)setProgressViewType:(MSProgressViewType)progressViewType
{
    _progressViewType = progressViewType;
    
    if (self.progressViewType == MSProgressViewType_showPreogressButton) {
        self.lbPercent.layer.cornerRadius = 7;
        self.lbPercent.layer.borderColor = CG_RGB(94, 140, 228);
        self.lbPercent.layer.borderWidth = 1;
        self.lbPercent.clipsToBounds = YES;
    }else{
        self.lbPercent.backgroundColor = [UIColor clearColor];
    }
    
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress >= 0 ? progress : 0;
    
    self.layer.cornerRadius = self.frame.size.height / 2.0;
    self.gradientLayer.cornerRadius = self.frame.size.height / 2.0;
    
    NSString *progressStr = nil;
    if (self.progress >= 10) {
        progressStr = [NSString stringWithFormat:@"≥999%%"];
    }else{
        progressStr = [NSString stringWithFormat:@"%.f%%",self.progress*100];
    }
    CGSize size = [progressStr sizeWithAttributes:@{NSFontAttributeName : self.lbPercent.font}];
    self.lbPercent.text = progressStr;
    
    
    if (self.progressViewType == MSProgressViewType_showPreogressButton) {
        if (self.progress >= 1) {
            self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            self.lbPercent.backgroundColor = RGB(94, 140, 228);
            self.lbPercent.textColor = [UIColor whiteColor];
            self.lbPercent.frame = CGRectMake(self.frame.size.width - (size.width + 7), -(15 - self.frame.size.height)/2.0, size.width + 7, 14);
            
        }
        else{
            self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width * self.progress, self.frame.size.height);
            self.lbPercent.backgroundColor = [UIColor whiteColor];
            self.lbPercent.textColor = RGB(94, 140, 228);
            
            CGFloat width = self.gradientLayer.frame.size.width + DEFAULTWIDTH;
            if (width < self.frame.size.width) {
                self.lbPercent.frame = CGRectMake(self.frame.size.width * self.progress - 1, (self.frame.size.height - 15)/2.0, DEFAULTWIDTH, 14);
            }else{
                self.lbPercent.frame = CGRectMake(self.frame.size.width - DEFAULTWIDTH, (self.frame.size.height - 15)/2.0, DEFAULTWIDTH, 14);
            }
            
        }
    }
    else{
        if (self.progress >= 1) {
            self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            self.lbPercent.textColor = RGB(94, 140, 228);
        }
        else{
            self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width * self.progress, self.frame.size.height);
            self.lbPercent.textColor = RGB(156, 156, 156);
        }
        
        self.lbPercent.frame = CGRectMake(self.frame.size.width + 2, -(15 - self.frame.size.height)/2.0, size.width + 7, 14);
    }

}

@end
