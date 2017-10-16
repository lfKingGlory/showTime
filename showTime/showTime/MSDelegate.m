//
//  MSDelegate.m
//  showTime
//
//  Created by msj on 2017/1/10.
//  Copyright © 2017年 msj. All rights reserved.
//

#import "MSDelegate.h"

@implementation MSDelegate
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL seletor = [anInvocation selector];
    if ([self.firstDelegate respondsToSelector:seletor]) {
        [anInvocation invokeWithTarget:self.firstDelegate];
    }
    
    if ([self.secondDelegate respondsToSelector:seletor]) {
        [anInvocation invokeWithTarget:self.secondDelegate];
    }
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *first = [(NSObject *)self.firstDelegate methodSignatureForSelector:aSelector];
    NSMethodSignature *second = [(NSObject *)self.secondDelegate methodSignatureForSelector:aSelector];
    if (first) {
        return first;
    }
    if (second) {
        return second;
    }
    return nil;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    
    if ([self.firstDelegate respondsToSelector:aSelector] || [self.secondDelegate respondsToSelector:aSelector]) {
        return YES;
    }
    return NO;
}

@end
