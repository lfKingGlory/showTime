//
//  MSVerificationCodeView.m
//  showTime
//
//  Created by msj on 2016/12/21.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSVerificationCodeView.h"
#import "UIColor+StringColor.h"
#import "UIView+FrameUtil.h"
#import "MSCountDownView.h"

#define screenWidth    [UIScreen mainScreen].bounds.size.width

@interface MSCodeTextField : UITextField
@end
@implementation MSCodeTextField
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{ return NO; }
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}
- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect rightViewRect = [super rightViewRectForBounds:bounds];
    rightViewRect.origin.x -= 10;
    return rightViewRect;
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds.origin.x += 10;
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    bounds.origin.x += 10;
    return bounds;
}
@end

@interface MSVerificationCodeView ()
@property (strong, nonatomic) MSCountDownView *countDownView;
@property (strong, nonatomic) UILabel *lbPhone;
@property (strong, nonatomic) MSCodeTextField *textField;
@property (strong, nonatomic) UIButton *btnCast;
@end

@implementation MSVerificationCodeView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        
        self.backgroundColor = [UIColor ms_colorWithHexString:@"#F8F8F8"];
        
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, screenWidth, 18)];
        lbTitle.textColor = [UIColor ms_colorWithHexString:@"#323232"];
        lbTitle.text = @"请输入验证码";
        lbTitle.textAlignment = NSTextAlignmentCenter;
        lbTitle.font = [UIFont systemFontOfSize:18];
        [self addSubview:lbTitle];
        
        UIImageView *cancelIcon = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 15 - 23, 0, 23, 23)];
        cancelIcon.centerY = lbTitle.centerY;
        cancelIcon.image = [UIImage imageNamed:@"pay_cancel"];
        cancelIcon.userInteractionEnabled = YES;
        [cancelIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)]];
        [self addSubview:cancelIcon];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(16, 48, screenWidth - 32, 0.5)];
        line.backgroundColor = [UIColor ms_colorWithHexString:@"DADADA"];
        [self addSubview:line];
        
        self.lbPhone = [[UILabel alloc] initWithFrame:CGRectMake(16, 58.5, screenWidth - 32, 12)];
        self.lbPhone.textAlignment = NSTextAlignmentLeft;
        self.lbPhone.textColor = [UIColor ms_colorWithHexString:@"#969696"];
        self.lbPhone.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.lbPhone];
        
        self.textField = [[MSCodeTextField alloc] initWithFrame:CGRectMake(15, 80.5, screenWidth - 30, 51)];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"请输入短信验证码" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor ms_colorWithHexString:@"CFCFCF"]}];
        self.textField.attributedPlaceholder = attStr;
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.layer.borderColor = [UIColor ms_colorWithHexString:@"#DCDCDC"].CGColor;
        self.textField.layer.borderWidth = 0.5;
        [self addSubview:self.textField];
//        self.textField.inputAccessoryView = [[MSInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
        
        self.countDownView = [[MSCountDownView alloc] initWithFrame:CGRectMake(0, 0, 90, 36)];
        __weak typeof(self)weakSelf = self;
        self.countDownView.willBeginCountdown = ^{
            if (weakSelf.getVerificationCodeBlock) {
                weakSelf.getVerificationCodeBlock();
            }
        };
        self.textField.rightView = self.countDownView;
        self.textField.rightViewMode = UITextFieldViewModeAlways;
        
        self.btnCast = [[UIButton alloc] initWithFrame:CGRectMake(13, 161.5, screenWidth - 26, 42)];
        [self.btnCast setBackgroundImage:[UIImage imageNamed:@"button_all"] forState:UIControlStateNormal];
        [self.btnCast setTitle:@"确认" forState:UIControlStateNormal];
        self.btnCast.enabled = NO;
        [self addSubview:self.btnCast];
        [self.btnCast addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)becomeFirstResponder
{
    [self.textField becomeFirstResponder];
}
- (void)resignFirstResponder
{
    [self.textField resignFirstResponder];
}

- (void)beginCountDown
{
    self.countDownView.currentMode = MSCountDownViewModeCountDown;
}

- (void)setPhoneNumber:(NSString *)phoneNumber
{
    _phoneNumber = phoneNumber;
    self.lbPhone.text = [NSString stringWithFormat:@"已向尾号%@的手机发送短信验证码",phoneNumber];
}

- (void)cancel
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
- (void)sure
{
    if (self.makeSureBlock) {
        self.makeSureBlock(self.textField.text);
    }
}
#pragma mark - 通知
- (void)textDidChange:(NSNotification *)noti
{
    self.btnCast.enabled = self.textField.text.length >= 6 ? YES : NO;
    if (self.textField.text.length > 6) {
        self.textField.text = [self.textField.text substringWithRange:NSMakeRange(0, 6)];
    }
}
@end
