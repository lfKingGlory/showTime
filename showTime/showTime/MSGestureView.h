//
//  MSGestureView.h
//  showTime
//
//  Created by msj on 16/9/18.
//  Copyright © 2016年 刘飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSGestureView;

typedef enum {
    MSGestureView_normal,
    MSGestureView_error
}MSGestureViewType;

@protocol MSGestureViewDelegate <NSObject>
@optional
- (void)ms_gestureView:(MSGestureView *)gestureView didSelectedPassword:(NSString *)passWord;
@end

@interface MSGestureView : UIView
@property (weak, nonatomic) id <MSGestureViewDelegate>delegate;
@property (assign, nonatomic) MSGestureViewType gestureViewType;
@end
