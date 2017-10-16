//
//  MSTradePasswordView.m
//  showTime
//
//  Created by msj on 2016/12/21.
//  Copyright © 2016年 msj. All rights reserved.
//
#import "MSTradePasswordView.h"
#import "UIColor+StringColor.h"
#import "UIView+FrameUtil.h"
#import "MSPinView.h"

#define screenWidth    [UIScreen mainScreen].bounds.size.width

@interface MSTradePasswordView ()
@property (strong, nonatomic) MSPinView *pinView;
@property (strong, nonatomic) UILabel *lbMoney;
@property (strong, nonatomic) UILabel *lbProtocol;
@property (strong, nonatomic) UIImageView *imageTips;
@property (strong, nonatomic) UILabel *lbTips;
@end

@implementation MSTradePasswordView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor ms_colorWithHexString:@"#F8F8F8"];
        
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, screenWidth, 18)];
        lbTitle.textColor = [UIColor ms_colorWithHexString:@"#323232"];
        lbTitle.text = @"请输入交易密码";
        lbTitle.textAlignment = NSTextAlignmentCenter;
        lbTitle.font = [UIFont systemFontOfSize:18];
        [self addSubview:lbTitle];
        
        UIImageView *cancelIcon = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 15 - 23, 0, 23, 23)];
        cancelIcon.centerY = lbTitle.centerY;
        cancelIcon.image = [UIImage imageNamed:@"pay_cancel"];
        cancelIcon.userInteractionEnabled = YES;
        [cancelIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)]];
        [self addSubview:cancelIcon];
        
        self.lbMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, screenWidth, 14)];
        self.lbMoney.textColor = [UIColor ms_colorWithHexString:@"#969696"];
        self.lbMoney.textAlignment = NSTextAlignmentCenter;
        self.lbMoney.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.lbMoney];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(16, 68, screenWidth - 32, 0.5)];
        line.backgroundColor = [UIColor ms_colorWithHexString:@"DADADA"];
        [self addSubview:line];
        
        CGFloat distance = 28.5;
        CGFloat pinViewX = distance;
        CGFloat pinViewW = screenWidth - distance*2;
        CGFloat pinViewH = (screenWidth - distance*2)/6.0;
        CGFloat pinViewY = 96.5;
        self.pinView = [[MSPinView alloc] initWithFrame:CGRectMake(pinViewX, pinViewY, pinViewW, pinViewH)];
        __weak typeof(self)weakSelf = self;
        self.pinView.finish = ^(NSString *password){
            if (weakSelf.finishBlock) {
                weakSelf.finishBlock(password);
            }
        };
        [self addSubview:self.pinView];
        
        self.imageTips = [[UIImageView alloc] initWithFrame:CGRectMake(distance, 76.5, 12, 12)];
        self.imageTips.image = [UIImage imageNamed:@"info_tips"];
        [self addSubview:self.imageTips];
        
        self.lbTips = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageTips.frame)+4, 0, screenWidth - (CGRectGetMaxX(self.imageTips.frame)+4), 12)];
        self.lbTips.centerY = self.imageTips.centerY;
        self.lbTips.text = @"交易密码不正确，请重新输入";
        self.lbTips.textAlignment = NSTextAlignmentLeft;
        self.lbTips.textColor = [UIColor ms_colorWithHexString:@"#ED1B23"];
        self.lbTips.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.lbTips];
        
        self.imageTips.hidden = YES;
        self.lbTips.hidden = YES;
        
        UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 87 - distance, CGRectGetMaxY(self.pinView.frame)+10, 87, 14)];
        [btnCancel setTitle:@"忘记交易密码" forState:UIControlStateNormal];
        [btnCancel setTitleColor:[UIColor ms_colorWithHexString:@"#5C4E9C"] forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnCancel addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCancel];
        
        self.lbProtocol = [[UILabel alloc] initWithFrame:CGRectMake(0, 210, screenWidth, 14)];
        self.lbProtocol.textAlignment = NSTextAlignmentCenter;
        self.lbProtocol.font = [UIFont systemFontOfSize:14];
        self.lbProtocol.userInteractionEnabled = YES;
        [self.lbProtocol addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookProtocol)]];
        [self addSubview:self.lbProtocol];
    }
    return self;
}

- (void)setIsHideProtocol:(BOOL)isHideProtocol
{
    _isHideProtocol = isHideProtocol;
    self.lbMoney.hidden = isHideProtocol;
    self.lbProtocol.hidden = isHideProtocol;
}

- (void)setIsPasswordSuccess:(BOOL)isPasswordSuccess
{
    _isPasswordSuccess = isPasswordSuccess;
    self.imageTips.hidden = isPasswordSuccess;
    self.lbTips.hidden = isPasswordSuccess;
}

- (void)setMoney:(NSString *)money
{
    _money = money;
    self.lbMoney.text = money;
}

- (void)setProtocolName:(NSString *)protocolName
{
    _protocolName = protocolName;
    NSString *str = @"输入密码，即表示您同意";
    NSString *name = [NSString stringWithFormat:@"《%@》",protocolName];
    NSMutableAttributedString  *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName : [UIColor ms_colorWithHexString:@"646464"]}];
    NSMutableAttributedString  *attName = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName : [UIColor ms_colorWithHexString:@"5C4E9C"]}];
    [attStr appendAttributedString:attName];
    self.lbProtocol.attributedText = attStr;
}

- (void)forgetPassword
{
    if (self.forgetPasswordBlock) {
        self.forgetPasswordBlock();
    }
}

- (void)lookProtocol
{
    if (self.lookProtocolBlock) {
        self.lookProtocolBlock();
    }
}

- (void)cancel
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)becomeFirstResponder
{
    [self.pinView becomeFirstResponder];
}
- (void)resignFirstResponder
{
    [self.pinView resignFirstResponder];
}
- (void)reset
{
    [self.pinView reset];
}

@end
