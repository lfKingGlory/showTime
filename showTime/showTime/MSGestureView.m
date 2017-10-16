//
//  MSGestureView.h
//  showTime
//
//  Created by msj on 16/9/18.
//  Copyright © 2016年 刘飞. All rights reserved.
//


#import "MSGestureView.h"
#import "MSGestureItem.h"
#define RGB(r,g,b)  [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1]

@interface MSGestureView ()
@property (strong, nonatomic) NSMutableArray *items;
@property (assign, nonatomic) CGPoint currentPoint;
@end

@implementation MSGestureView

- (void)setGestureViewType:(MSGestureViewType)gestureViewType
{
    _gestureViewType = gestureViewType;
    
    if (gestureViewType == MSGestureView_normal) {
        
        self.userInteractionEnabled = YES;
        
        self.currentPoint = CGPointZero;
        
        [self.items enumerateObjectsUsingBlock:^(__kindof MSGestureItem * _Nonnull item, NSUInteger index, BOOL * _Nonnull stop) {
            item.gestureItemType = MSGestureItem_normal;
        }];
        
        [self.items removeAllObjects];
    }else{
        
        self.userInteractionEnabled = NO;
        
        for (MSGestureItem *item in self.items) {
            item.gestureItemType = MSGestureItem_error;
        }
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.items.count == 0) {
        return;
    }
    
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    
    for (int  i = 0; i < self.items.count; i++) {
        MSGestureItem *item = self.items[i];
        if (0 == i) {
            CGContextMoveToPoint(ctx, item.center.x, item.center.y);
        }else
        {
            CGContextAddLineToPoint(ctx, item.center.x, item.center.y);
        }
    }
    
    if (self.items.count != 0) {
        CGContextAddLineToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
    }
    
    UIColor *color = self.gestureViewType == MSGestureView_normal ? RGB(51, 48, 146) : RGB(218, 27, 39);
    [color set];
    CGContextSetLineWidth(ctx, 2);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextStrokePath(ctx);
}

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self addItems];
    }
    return self;
}

- (void)addItems
{
    for (int i = 0; i < 9; i++) {
        MSGestureItem *item = [[MSGestureItem alloc] init];
        item.userInteractionEnabled = NO;
        item.tag = i + 1;
        [self addSubview:item];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat itemMargin = 43;
    CGFloat itemW = (self.frame.size.width - itemMargin * 2) / 3.0;
    CGFloat itemH = itemW;
    
    for (int i = 0; i < 9; i++) {
        CGFloat itemX = (i % 3) * (itemW + itemMargin);
        CGFloat itemY = (i / 3) * (itemH + itemMargin);
        MSGestureItem *item = self.subviews[i];
        item.frame = CGRectMake(itemX, itemY, itemW, itemH);
        item.gestureItemType = MSGestureItem_normal;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [self getCurrentTouchPoint:touches];
    MSGestureItem *item = [self getCurrentItemWithPoint:point];
    if (item) {
        item.gestureItemType = MSGestureItem_success;
        [self.items addObject:item];
    }
    self.currentPoint = point;
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [self getCurrentTouchPoint:touches];
    MSGestureItem *item = [self getCurrentItemWithPoint:point];
    
    if (item && item.gestureItemType == MSGestureItem_normal) {
        item.gestureItemType = MSGestureItem_success;
        [self.items addObject:item];
    }
    
    self.currentPoint = point;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSMutableString *passWord = [NSMutableString string];
    for (MSGestureItem *item in self.items) {
        [passWord appendFormat:@"%d", (int)item.tag ];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(ms_gestureView:didSelectedPassword:)]) {
        [self.delegate ms_gestureView:self didSelectedPassword:passWord];
        //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  错误震动
    }
    
}


- (CGPoint)getCurrentTouchPoint:(NSSet <UITouch *> *)touches
{
    UITouch *touch =  [touches anyObject];
    return [touch locationInView:touch.view];
}

- (MSGestureItem *)getCurrentItemWithPoint:(CGPoint)point
{
    for (MSGestureItem *item in self.subviews) {
        if (CGRectContainsPoint(item.frame, point)) {
            return item;
        }
    }
    return nil;
}
@end
