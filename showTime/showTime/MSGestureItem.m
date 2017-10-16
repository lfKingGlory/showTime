//
//  MSGestureView.h
//  showTime
//
//  Created by msj on 16/9/18.
//  Copyright © 2016年 刘飞. All rights reserved.
//

#import "MSGestureItem.h"
#define RGB(r,g,b)  [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1]

@implementation MSGestureItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setGestureItemType:(MSGestureItemType)gestureItemType
{
    _gestureItemType = gestureItemType;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = self.bounds.size.width / 2.0;
    self.layer.masksToBounds = YES;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat x = rect.size.width * 0.5;
    CGFloat y = rect.size.height * 0.5;
    CGFloat outerRadius = rect.size.width * 0.5 - 1;
    CGFloat innerRadius = self.frame.size.width / 5.0;
    CGFloat startAngle = - M_PI_2;
    CGFloat endAngle = M_PI * 3 / 2;
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 1);
    [[self outerCircleColor] set];
    CGContextAddArc(context, x, y, outerRadius, startAngle, endAngle, 0);
    CGContextStrokePath(context);
    
    
    [[self innerCircleColor] set];
    CGContextAddArc(context, x, y, innerRadius, startAngle, endAngle, 0);
    CGContextFillPath(context);

}

- (UIColor *)outerCircleColor
{
    switch (self.gestureItemType) {
        case MSGestureItem_success:  return RGB(51, 48, 146);
        case MSGestureItem_error:    return RGB(218, 27, 39);
        case MSGestureItem_normal:
        default:                     return RGB(175, 176, 168);
    }
}

- (UIColor *)innerCircleColor
{
    switch (self.gestureItemType) {
        case MSGestureItem_success:  return RGB(51, 48, 146);
        case MSGestureItem_error:    return RGB(218, 27, 39);
        case MSGestureItem_normal:
        default:                     return [UIColor clearColor];
    }
}
@end
