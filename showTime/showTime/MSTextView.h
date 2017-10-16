//
//  customTextView.h
//  customTextView
//
//  Created by BBM on 15/7/12.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTextView : UITextView
@property(nonatomic, copy)NSString *placeholder;
@property(nonatomic, strong)UIColor *placeholderColor;
@property(nonatomic, strong) UIFont *placeholderFont;
@end
