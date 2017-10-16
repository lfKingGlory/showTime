//
//  customTextView.m
//  customTextView
//
//  Created by 刘飞 on 15/7/12.
//  Copyright (c) 2015年 刘飞. All rights reserved.
//

#import "MSTextView.h"

@interface MSTextView ()
@property(nonatomic, strong)UILabel *placeHolderLabel;
@end

@implementation MSTextView
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self configueElement];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configueElement {
    
    _placeHolderLabel = [[UILabel alloc] init];
    _placeHolderLabel.font = [UIFont systemFontOfSize:15];
    _placeHolderLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2];
    _placeHolderLabel.numberOfLines = 0;
    
    [self insertSubview:_placeHolderLabel atIndex:0];
    self.alwaysBounceVertical = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    
}

- (void)textDidChange{
    
    if (self.text.length) {
        [self.placeHolderLabel removeFromSuperview];
    }else{
        [self insertSubview:_placeHolderLabel atIndex:0];
    }
}

- (void)setPlaceholder:(NSString *)placeholder{
    
    if (![placeholder isKindOfClass:[NSString class]]) {
        return;
    }
    
    if (placeholder.length == 0) {
        return;
    }
    
    _placeholder = [placeholder copy];
    
    if (placeholder && placeholder.length > 0) {
        CGSize size = [placeholder boundingRectWithSize:CGSizeMake(self.frame.size.width - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _placeHolderLabel.font} context:nil].size;
        _placeHolderLabel.frame = CGRectMake(5, 6, size.width, size.height);
        _placeHolderLabel.text = placeholder;
    }
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeHolderLabel.font = placeholderFont;
    [self setPlaceholder:_placeholder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeHolderLabel.textColor = placeholderColor;
}

@end
