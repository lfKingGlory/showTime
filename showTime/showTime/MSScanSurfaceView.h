//
//  MSScanSurfaceView.h
//  showTime
//
//  Created by msj on 16/9/27.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSScanSurfaceView : UIView
{
    CALayer *baselineLayer;
    BOOL isAnimation;
}

@property(nonatomic,assign)CGRect scanRect;

-(void)startBaseLineAnimation;
-(void)stopBaseLineAnimation;
@end