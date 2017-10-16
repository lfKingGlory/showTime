
//
//  MSAssetTitleView.m
//  showTime
//
//  Created by msj on 16/10/13.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSAssetTitleView.h"

@interface MSAssetTitleView ()
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *lbTitle;
@property (assign, nonatomic) ArrowDirection direction;
@end

@implementation MSAssetTitleView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.iconImageView = [[UIImageView alloc] init];
        self.iconImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.iconImageView];
        
        self.lbTitle = [[UILabel alloc] init];
        self.lbTitle.font = [UIFont systemFontOfSize:14];
        self.lbTitle.textAlignment = NSTextAlignmentCenter;
        self.lbTitle.textColor = [UIColor whiteColor];
        [self addSubview:self.lbTitle];
        
        self.direction = ArrowDirectionDown;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
     
    }
    return self;
}

- (void)tap
{
    if (self.direction == ArrowDirectionDown) {
        self.direction = ArrowDirectionUp;
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.iconImageView.transform = CGAffineTransformMakeRotation(-M_PI);
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
        
    }else if(self.direction == ArrowDirectionUp){
        self.direction = ArrowDirectionDown;
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.iconImageView.transform = CGAffineTransformRotate(self.iconImageView.transform, M_PI);
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
    }

    if (self.changeDirectionBlock) {
        self.changeDirectionBlock(self.direction);
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    [self updateFrame];
}

- (void)updateFrame
{
    CGSize size = [self.title sizeWithAttributes:@{NSFontAttributeName : self.lbTitle.font}];
    
    CGRect frame = self.frame;
    frame.size.width = 15 + 12.5 + size.width;
    self.frame = frame;
    
    self.lbTitle.frame = CGRectMake(5, (self.frame.size.height - size.height)/2.0, size.width, size.height);
    self.iconImageView.frame = CGRectMake(CGRectGetMaxX(self.lbTitle.frame) + 5, (self.frame.size.height - 7.5)/2.0, 12.5, 7.5);
    
    self.lbTitle.text = self.title;
    self.iconImageView.image = [UIImage imageNamed:@"assetArrow"];
    

}

- (void)updateTitle:(NSString *)title
{
    self.title = title;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.iconImageView.transform = CGAffineTransformRotate(self.iconImageView.transform, M_PI);
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
    self.direction = ArrowDirectionDown;
}

@end
