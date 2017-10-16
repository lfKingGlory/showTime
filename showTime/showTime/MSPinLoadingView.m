//
//  MSPinLoadingView.m
//  showTime
//
//  Created by msj on 2016/12/21.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSPinLoadingView.h"
#import "UIImage+GIF.h"
#import "UIColor+StringColor.h"

@interface MSPinLoadingTextField : UITextField
@end
@implementation MSPinLoadingTextField
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{ return NO; }
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{ return NO; }
@end

@interface MSPinLoadingView ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *lbTips;
@property (strong, nonatomic) MSPinLoadingTextField *textField;
@end

@implementation MSPinLoadingView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor ms_colorWithHexString:@"#F8F8F8"];
        
        self.textField = [[MSPinLoadingTextField alloc] initWithFrame:self.bounds];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.textColor = [UIColor clearColor];
        self.textField.tintColor = [UIColor clearColor];
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:self.textField];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 50)/2.0, (self.frame.size.height - 50)/2.0, 50, 50)];
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2.0;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.image = [UIImage sd_animatedGIFNamed:@"321"];
        [self addSubview:self.imageView];
        
        self.lbTips = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 13, self.frame.size.width, 14)];
        self.lbTips.textAlignment = NSTextAlignmentCenter;
        self.lbTips.font = [UIFont systemFontOfSize:14];
        self.lbTips.textColor = [UIColor ms_colorWithHexString:@"#000000"];
        [self addSubview:self.lbTips];
        self.lbTips.text = @"验证中...";
        
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
@end
