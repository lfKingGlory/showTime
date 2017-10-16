//
//  MSBubbleTransition.m
//  showTime
//
//  Created by msj on 16/11/3.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSBubbleTransition.h"

@implementation MSBubbleTransition

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bubbleColor = [UIColor whiteColor];
        self.transitionMode = MSBubbleTransitionMode_present;
        self.startingPoint = CGPointZero;
        self.duration = 0.4;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = transitionContext.containerView;
    
    if (self.transitionMode == MSBubbleTransitionMode_present) {
        
        UIView *presentedControllerView = [transitionContext viewForKey:UITransitionContextToViewKey];
        CGPoint originalCenter = presentedControllerView.center;
        CGSize originalSize = presentedControllerView.frame.size;
        
        self.bubbleView = [[UIView alloc] init];
        self.bubbleView.frame = [self frameForBubbleView:originalCenter originalSize:originalSize start:self.startingPoint];
        self.bubbleView.layer.cornerRadius = self.bubbleView.frame.size.height / 2;
        self.bubbleView.layer.masksToBounds = YES;
        self.bubbleView.center = self.startingPoint;
        self.bubbleView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        self.bubbleView.backgroundColor = self.bubbleColor;
        [containerView addSubview:self.bubbleView];
        
        presentedControllerView.center = self.startingPoint;
        presentedControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        presentedControllerView.alpha = 0;
        [containerView addSubview:presentedControllerView];
        
        
        [UIView animateWithDuration:self.duration animations:^{
            self.bubbleView.transform = CGAffineTransformIdentity;
            presentedControllerView.transform = CGAffineTransformIdentity;
            presentedControllerView.alpha = 1;
            presentedControllerView.center = originalCenter;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        
        
    }else{
        
        UIView *returningControllerView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        CGPoint originalCenter = returningControllerView.center;
        CGSize originalSize = returningControllerView.frame.size;
        
        self.bubbleView.frame = [self frameForBubbleView:originalCenter originalSize:originalSize start:self.startingPoint];
        self.bubbleView.layer.cornerRadius = self.bubbleView.frame.size.height / 2;
        self.bubbleView.layer.masksToBounds = YES;
        self.bubbleView.center = self.startingPoint;
        
        [UIView animateWithDuration:self.duration animations:^{
            self.bubbleView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            returningControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            returningControllerView.alpha = 0;
            returningControllerView.center = self.startingPoint;
        } completion:^(BOOL finished) {
            returningControllerView.center = originalCenter;
            [returningControllerView removeFromSuperview];
            [self.bubbleView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    }
}

- (CGRect)frameForBubbleView:(CGPoint)originalCenter originalSize:(CGSize)originalSize start:(CGPoint)start
{
    CGFloat lengthX = fmax(start.x, originalSize.width - start.x);
    CGFloat lengthY = fmax(start.y, originalSize.height - start.y);
    CGFloat offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2;
    return CGRectMake(0, 0, offset, offset);
}
@end
