//
//  MSIndicator.m
//  showTime
//
//  Created by msj on 2017/1/10.
//  Copyright © 2017年 msj. All rights reserved.
//

#import "MSIndicator.h"

@interface MSIndicator ()
@property (strong, nonatomic) UILabel *lbTips;
@end

@implementation MSIndicator

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.lbTips = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:self.lbTips];
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"MSIndicatorMSIndicatorMSIndicatorMSIndicator");
}

@end
