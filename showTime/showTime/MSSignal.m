
//
//  MSSignal.m
//  showTime
//
//  Created by msj on 2017/4/18.
//  Copyright © 2017年 msj. All rights reserved.
//

#import "MSSignal.h"

@implementation MSSignal
+ (instancetype)m_signal {
    static MSSignal *signal = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        signal = [[MSSignal alloc] init];
    });
    return signal;
}
@end
