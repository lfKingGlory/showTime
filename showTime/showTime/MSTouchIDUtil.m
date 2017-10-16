//
//  MSTouchIDUtil.m
//  FingerPrint
//
//  Created by msj on 2017/10/11.
//  Copyright © 2017年 kosienDGL. All rights reserved.
//

#import "MSTouchIDUtil.h"
#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

@implementation MSTouchIDUtil
+ (void)ms_evaluateWithReplyBlock:(MSReplyBlock)replyBlock {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8) {
        replyBlock(MSTouchModelNotSupport, @"该设备不支持TouchID");
        return;
    }
    
    LAContext *context = [[LAContext alloc] init];
    NSError *Error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&Error]) {
        //TouchID 可用
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSLog(@"指纹验证成功");
                    replyBlock(MSTouchModelAuthenticationSuccess, @"指纹验证成功");
                }];
            } else {
                switch (error.code) {
                    case LAErrorSystemCancel:
                    case LAErrorAppCancel:
                    case LAErrorInvalidContext: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"系统取消授权，如其他APP切入");
                            replyBlock(MSTouchModelCancel, @"系统取消授权");
                        }];
                    }
                        break;
                    case LAErrorUserCancel:{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户取消验证，点击了取消按钮");
                            replyBlock(MSTouchModelCancel, @"用户取消验证");
                        }];
                    }
                        break;
                    case LAErrorUserFallback:{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户取消验证，点击了输入密码按钮");
                            replyBlock(MSTouchModelCancel, @"用户取消验证");
                        }];
                    }
                        break;
                    case LAErrorAuthenticationFailed:{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"连续三次指纹验证失败，可能指纹模糊或用错手指");
                            replyBlock(MSTouchModelAuthenticationFailed, @"超出TouchID重试次数");
                        }];
                    }
                        break;
                    case LAErrorTouchIDLockout:{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"连续五次指纹验证失败, 设备TouchID被锁定，因为失败的次数太多了");
                            replyBlock(MSTouchModelTouchIDLockout, @"超出TouchID重试次数");
                        }];
                    }
                        break;
                    default:{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"设备TouchID不可用");
                            replyBlock(MSTouchModelTouchIDNotAvailable, @"设备TouchID不可用");
                        }];
                    }
                        break;
                }
            }
        }];
        
    } else {
        
        //TouchID 不可用
        switch (Error.code) {
            case LAErrorPasscodeNotSet:{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSLog(@"指纹验证无法启动，因为设备没有设置密码");
                    replyBlock(MSTouchModelPasscodeNotSet, @"您还没有设置开机密码");
                }];
            }
                break;
            case LAErrorTouchIDNotEnrolled:{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSLog(@"指纹验证无法启动，因为没有录入指纹");
                    replyBlock(MSTouchModelTouchIDNotEnrolled, @"您还没有录入指纹");
                }];
            }
                break;
            case LAErrorTouchIDLockout:{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSLog(@"已经连续五次指纹验证失败, 设备TouchID被锁定，因为失败的次数太多了");
                    replyBlock(MSTouchModelTouchIDNotAvailable, @"设备TouchID不可用");
                }];
            }
                break;
            default:{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSLog(@"设备TouchID不可用");
                    replyBlock(MSTouchModelTouchIDNotAvailable, @"设备TouchID不可用");
                }];
            }
                break;
        }
    }
}
@end
