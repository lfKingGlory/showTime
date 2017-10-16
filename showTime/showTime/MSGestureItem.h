//
//  MSGestureView.h
//  showTime
//
//  Created by msj on 16/9/18.
//  Copyright © 2016年 刘飞. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum {
    MSGestureItem_normal,
    MSGestureItem_error,
    MSGestureItem_success
}MSGestureItemType;

@interface MSGestureItem : UIView
@property (assign, nonatomic) MSGestureItemType gestureItemType;
@end
