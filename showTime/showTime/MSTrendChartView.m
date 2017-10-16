//
//  MSTrendChartView.m
//  showTime
//
//  Created by msj on 2017/3/20.
//  Copyright © 2017年 msj. All rights reserved.
//

#import "MSTrendChartView.h"
#import "UIView+FrameUtil.h"
#import "MSDrawLine.h"
#define RGB(r,g,b)  [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1]
#define REALSPACEY  (self.chartView.height / self.lineCount)
#define LEFTMARGIN    65
#define RIGHTMARGIN   18

@interface MSTrendChartView ()<CAAnimationDelegate>
@property (strong, nonatomic) NSMutableArray *lbTrendArr;
@property (strong, nonatomic) NSMutableArray *lbTimeArr;
@property (strong, nonatomic) UIView *chartView;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) CAShapeLayer *trendChartLayer;
@property (strong, nonatomic) CAShapeLayer *maskShapeLayer;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;


@property (assign, nonatomic) CGFloat minTrend;
@property (assign, nonatomic) CGFloat maxTrend;
@property (assign, nonatomic) NSInteger lineCount;
@property (strong, nonatomic) UIColor *brokenLineColor;
@property (strong, nonatomic) NSArray *times;
@property (strong, nonatomic) NSArray *points;
@end

@implementation MSTrendChartView

- (NSMutableArray *)lbTrendArr {
    if (!_lbTrendArr) {
        _lbTrendArr = [NSMutableArray array];
    }
    return _lbTrendArr;
}

- (NSMutableArray *)lbTimeArr {
    if (!_lbTimeArr) {
        _lbTimeArr = [NSMutableArray array];
    }
    return _lbTimeArr;
}

- (CAShapeLayer *)trendChartLayer {
    if (!_trendChartLayer) {
        _trendChartLayer = [CAShapeLayer layer];
        _trendChartLayer.lineWidth = 1;
        _trendChartLayer.lineJoin = kCALineJoinRound;
        _trendChartLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _trendChartLayer;
}

- (CAShapeLayer *)maskShapeLayer {
    if (!_maskShapeLayer) {
        _maskShapeLayer = [CAShapeLayer layer];
//        _maskShapeLayer.strokeColor = [UIColor clearColor].CGColor;
        _maskShapeLayer.fillColor = [UIColor whiteColor].CGColor;
//        _maskShapeLayer.opacity = 0.3;
    }
    return _maskShapeLayer;
}

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
    }
    return _gradientLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.lineCount = 5;
        self.backgroundColor = [UIColor whiteColor];
        [self addSegmentedControl];
        [self drawDefaultChartView];
    }
    return self;
}

- (void)drawDefaultChartView {
    
    [self updateWithMinTrend:0 maxTrend:5 lineCount:5 brokenLineColor:RGB(206,206,206) times:@[@"02-06", @"02-08"] points:@[@0,@2.5,@5,@2.5,@0,@2.5,@5] mask:NO animation:NO];
    UILabel *lbTips = [[UILabel alloc] initWithFrame:self.chartView.bounds];
    lbTips.text = @"暂无数据";
    lbTips.textColor = RGB(206,206,206);
    lbTips.textAlignment = NSTextAlignmentCenter;
    lbTips.font = [UIFont systemFontOfSize:25];
    [self.chartView addSubview:lbTips];
    
}

- (void)setLineCount:(NSInteger)lineCount {
    if (lineCount < 2) {
        _lineCount = 5;
    }else{
        _lineCount = lineCount;
    }
}

- (void)updateWithMinTrend:(CGFloat)minTrend maxTrend:(CGFloat)maxTrend lineCount:(NSInteger)lineCount brokenLineColor:(UIColor *)brokenLineColor times:(NSArray *)times points:(NSArray *)points mask:(BOOL)mask animation:(BOOL)animation{
    
    if (minTrend >= maxTrend) {
        NSLog(@"minTrend 和 maxTrend大小不对");
        return;
    }
    
    if (!times || times.count == 0) {
        NSLog(@"时间轴没数据");
        return;
    }
    
    if (!points || points.count == 0) {
        NSLog(@"描点数据没有");
        return;
    }
    
    self.minTrend = minTrend;
    self.maxTrend = maxTrend;
    self.lineCount = lineCount;
    self.brokenLineColor = brokenLineColor;
    self.times = times;
    self.points = points;
    
    [self clear];
    [self addChartView];
    
    [self drawWithMin:self.minTrend max:self.maxTrend points:self.points mask:mask animation:animation];
}

- (void)clear {
    [self.chartView removeFromSuperview];
    [self.lbTimeArr removeAllObjects];
    [self.lbTrendArr removeAllObjects];
    [self.trendChartLayer removeFromSuperlayer];
    [self.trendChartLayer removeAllAnimations];
    self.trendChartLayer = nil;
    [self.maskShapeLayer removeFromSuperlayer];
    [self.maskShapeLayer removeAllAnimations];
    self.maskShapeLayer = nil;
    [self.gradientLayer removeFromSuperlayer];
    [self.gradientLayer removeAllAnimations];
    self.gradientLayer = nil;
}

- (void)addSegmentedControl {
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"近一月",@"近三月",@"近六月",@"近一年",nil];
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(70,70,70)} forState:UIControlStateSelected];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(166,166,166)} forState:UIControlStateNormal];
    self.segmentedControl.frame = CGRectMake((self.frame.size.width - 300)/2.0, 8, 300, 30);
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.tintColor =  RGB(206,206,206);
    [self addSubview:self.segmentedControl];
    [self.segmentedControl addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)addChartView {
    self.chartView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.width, self.height - 40)];
    [self addSubview:self.chartView];
    for (int i = 0; i < self.lineCount; i++) {
        NSArray *arr = @[NSStringFromCGPoint(CGPointMake(LEFTMARGIN, (REALSPACEY * i + REALSPACEY / 2.0))),
                         NSStringFromCGPoint(CGPointMake(self.width - RIGHTMARGIN, (REALSPACEY * i + REALSPACEY / 2.0)))];
        CALayer *layer = nil;
        if (i == self.lineCount - 1) {
            layer = [MSDrawLine drawSolidLineWidth:0.5 lineColor:RGB(206,206,206) points:arr];
        } else {
            layer = [MSDrawLine drawDotLineWidth:4 lineSpace:4 lineColor:RGB(206,206,206) points:arr];
        }
        [self.chartView.layer addSublayer:layer];
        
        UILabel *lbTrend = [[UILabel alloc] initWithFrame:CGRectMake(0, (REALSPACEY * i + REALSPACEY / 2.0 + 0.5/2.0 - 11/2.0), 50, 11)];
        lbTrend.font = [UIFont systemFontOfSize:11];
        lbTrend.textAlignment = NSTextAlignmentRight;
        lbTrend.textColor = RGB(151,151,151);
        [self.chartView addSubview:lbTrend];
        [self.lbTrendArr addObject:lbTrend];
    }
    
    CGFloat width = (self.width - (LEFTMARGIN + RIGHTMARGIN))/(self.times.count - 1);
    CGFloat height = REALSPACEY/2.0;
    CGFloat y = (self.chartView.height - REALSPACEY/2.0);
    for (int i = 0; i < self.times.count; i++) {
        CGFloat x = i * width + (LEFTMARGIN - width/2.0);
        UILabel *lbTime = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        lbTime.font = [UIFont systemFontOfSize:9];
        lbTime.textColor = RGB(151,151,151);
        lbTime.textAlignment = NSTextAlignmentCenter;
        [self.chartView addSubview:lbTime];
        [self.lbTimeArr addObject:lbTime];
    }
}

- (void)changeValue:(UISegmentedControl *)segmentedControl {
    if (self.block) {
        self.block((MSTrendChartViewMode)segmentedControl.selectedSegmentIndex);
    }
    
}

- (void)drawWithMin:(CGFloat)min max:(CGFloat)max points:(NSArray *)points mask:(BOOL)mask animation:(BOOL)animation{
    
    NSMutableArray *dataM = [NSMutableArray array];
    CGFloat sapceX = (self.width - (LEFTMARGIN + RIGHTMARGIN))/(points.count - 1);
    CGFloat spaceY = (max - min)/(self.lineCount - 1);

    [points enumerateObjectsUsingBlock:^(NSNumber  * _Nonnull value, NSUInteger index, BOOL * _Nonnull stop) {
        CGFloat x = index * sapceX + LEFTMARGIN;
        CGFloat y = self.chartView.height - ((value.floatValue - min)/spaceY * REALSPACEY + REALSPACEY/2.0);
        CGPoint point = CGPointMake(x, y);
        [dataM addObject:NSStringFromCGPoint(point)];
    }];
    
    [self.lbTrendArr enumerateObjectsUsingBlock:^(UILabel *  _Nonnull lbTrend, NSUInteger index, BOOL * _Nonnull stop) {
        if (index == 0) {
            lbTrend.text = [NSString stringWithFormat:@"%.4f",max];
        }else if (index == self.lbTrendArr.count - 1){
            lbTrend.text = [NSString stringWithFormat:@"%.4f",min];
        }else{
            lbTrend.text = [NSString stringWithFormat:@"%.4f",(max - index*spaceY)];
        }
    }];
    
    [self.lbTimeArr enumerateObjectsUsingBlock:^(UILabel *  _Nonnull lbTime, NSUInteger index, BOOL * _Nonnull stop) {
        lbTime.text = self.times[index];
    }];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [dataM enumerateObjectsUsingBlock:^(NSString *  _Nonnull pointStr, NSUInteger index, BOOL * _Nonnull stop) {
        CGPoint point = CGPointFromString(pointStr);
        if (index == 0) {
            [path moveToPoint:point];
        }else{
            [path addLineToPoint:point];
        }
    }];
    
    self.trendChartLayer.path = path.CGPath;
    self.trendChartLayer.strokeColor = self.brokenLineColor.CGColor;
    [self.chartView.layer addSublayer:self.trendChartLayer];
    
    if (animation) {
        CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAniamtion.duration = 1;
        pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAniamtion.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAniamtion.toValue = [NSNumber numberWithFloat:1.0];
        pathAniamtion.autoreverses = NO;
        pathAniamtion.fillMode = kCAFillModeForwards;
        pathAniamtion.delegate = self;
        [self.trendChartLayer addAnimation:pathAniamtion forKey:nil];
    }
    
    if (!mask) {
        return;
    }
    
    [dataM addObject:NSStringFromCGPoint(CGPointMake(LEFTMARGIN + (dataM.count - 1) * sapceX, self.chartView.height - REALSPACEY/2.0))];
    [dataM addObject:NSStringFromCGPoint(CGPointMake(LEFTMARGIN, self.chartView.height - REALSPACEY/2.0))];
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [dataM enumerateObjectsUsingBlock:^(NSString *  _Nonnull pointStr, NSUInteger index, BOOL * _Nonnull stop) {
        CGPoint point = CGPointFromString(pointStr);
        if (index == 0) {
            [maskPath moveToPoint:point];
        }else{
            [maskPath addLineToPoint:point];
        }
    }];
    [maskPath closePath];
    self.maskShapeLayer.path = maskPath.CGPath;
    self.maskShapeLayer.strokeColor = [UIColor clearColor].CGColor;
//    [self.chartView.layer addSublayer:self.maskShapeLayer];
    self.gradientLayer.mask = self.maskShapeLayer;
//    self.gradientLayer.colors = @[(id)self.brokenLineColor.CGColor, (id)[UIColor clearColor].CGColor];
    self.gradientLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor greenColor].CGColor, (id)[UIColor blueColor].CGColor];
    self.gradientLayer.locations = @[@0.25,@0.5,@0.75];
    [self.chartView.layer addSublayer:self.gradientLayer];
    
    if (animation) {
        CABasicAnimation *opacityAniamtion = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAniamtion.duration = 1.5;
        opacityAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        opacityAniamtion.fromValue = @0;
        opacityAniamtion.toValue = @0.3;
        opacityAniamtion.autoreverses = NO;
        opacityAniamtion.fillMode = kCAFillModeForwards;
        [self.gradientLayer addAnimation:opacityAniamtion forKey:nil];
    }
    
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"animationDidStop");
}

@end
