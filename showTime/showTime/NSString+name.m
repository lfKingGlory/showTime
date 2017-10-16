//
//  NSString+name.m
//  showTime
//
//  Created by msj on 2017/5/22.
//  Copyright © 2017年 msj. All rights reserved.
//

#import "NSString+name.h"
#import <objc/runtime.h>

static const int ms_name_key;

@implementation NSString (name)
- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, &ms_name_key, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, &ms_name_key);
}
@end
