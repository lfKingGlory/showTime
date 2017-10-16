//
//  MSTouchIDUtil.h
//  FingerPrint
//
//  Created by msj on 2017/10/11.
//  Copyright © 2017年 kosienDGL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MSTouchModel)
{
    /// 系统版本不支持TouchID
    MSTouchModelNotSupport,
    
    /// 用户取消验证 或者 系统取消授权
    MSTouchModelCancel,
    
    /// 验证成功
    MSTouchModelAuthenticationSuccess,
    
    /// 指纹验证无法启动，因为设备没有设置密码
    MSTouchModelPasscodeNotSet,
    
    /// 指纹验证无法启动，因为没有录入指纹
    MSTouchModelTouchIDNotEnrolled,
    
    /// 设备TouchID不可用，例如未打开
    MSTouchModelTouchIDNotAvailable,
    
    /// 连续三次指纹验证失败，可能指纹模糊或用错手指
    MSTouchModelAuthenticationFailed,
    
    /// 连续五次指纹验证失败, 设备TouchID被锁定，因为失败的次数太多了
    MSTouchModelTouchIDLockout
};

typedef void(^MSReplyBlock)(MSTouchModel model, NSString *message);

@interface MSTouchIDUtil : NSObject
+ (void)ms_evaluateWithReplyBlock:(MSReplyBlock)replyBlock;
@end
