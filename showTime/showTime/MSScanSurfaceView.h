//
//  MSScanSurfaceView.h
//  showTime
//
//  Created by msj on 16/9/27.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSScanSurfaceView : UIView
@property(nonatomic, assign, readonly)CGRect scanRect;
- (void)startAnimation;
- (void)stopAnimation;
@end
