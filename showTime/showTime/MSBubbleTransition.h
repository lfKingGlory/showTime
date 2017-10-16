//
//  MSBubbleTransition.h
//  showTime
//
//  Created by msj on 16/11/3.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    MSBubbleTransitionMode_present,
    MSBubbleTransitionMode_dismiss
}MSBubbleTransitionMode;

@interface MSBubbleTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (assign, nonatomic) CGPoint startingPoint;
@property (assign, nonatomic) CGFloat duration;
@property (assign, nonatomic) MSBubbleTransitionMode transitionMode;
@property (strong, nonatomic) UIColor *bubbleColor;
@property (strong, nonatomic) UIView *bubbleView;
@end
