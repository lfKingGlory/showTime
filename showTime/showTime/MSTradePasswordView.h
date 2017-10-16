//
//  MSTradePasswordView.h
//  showTime
//
//  Created by msj on 2016/12/21.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTradePasswordView : UIView
@property (copy, nonatomic) void (^finishBlock)(NSString *password);
@property (copy, nonatomic) void (^forgetPasswordBlock)(void);
@property (copy, nonatomic) void (^lookProtocolBlock)(void);
@property (copy, nonatomic) void (^cancelBlock)(void);

@property (assign, nonatomic) BOOL isHideProtocol;
@property (assign, nonatomic) BOOL isPasswordSuccess;
@property (copy, nonatomic) NSString *money;
@property (copy, nonatomic) NSString *protocolName;


- (void)becomeFirstResponder;
- (void)resignFirstResponder;
- (void)reset;

- (instancetype)init __attribute__((unavailable("init不可用，请使用initWithFrame:")));
+ (instancetype)new __attribute__((unavailable("new不可用，请使用initWithFrame:")));
@end
