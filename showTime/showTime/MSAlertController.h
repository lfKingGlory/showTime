//
//  MSAlertController.h
//  showTime
//
//  Created by msj on 2016/12/30.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSAlertAction : UIAlertAction
@property (strong, nonatomic)  UIColor *mstextColor; /**< 按钮title字体颜色 */
@end

@interface MSAlertController : UIAlertController
@property (strong, nonatomic) UIColor *mstintColor; /**< 统一按钮样式 不写系统默认的蓝色 */
@property (strong, nonatomic) UIColor *mstitleColor; /**< 标题的颜色 */
@property (strong, nonatomic) UIColor *msmessageColor; /**< 信息的颜色 */
@end
