//
//  NSString+URLEncoding.h
//  bbm(user)
//
//  Created by 王洋洋 on 15/4/6.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)

//编码
- (NSString *)URLEncodedString;

//解码
- (NSString *)URLDecodedString;

@end
