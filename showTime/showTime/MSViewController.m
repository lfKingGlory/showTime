//
//  MSViewController.m
//  showTime
//
//  Created by msj on 16/8/18.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSViewController.h"
#import "MSGuidanceUntil.h"

@implementation MSViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    MSGuidanceView *guidanceView = [[MSGuidanceView alloc] init];
    [guidanceView showWithClassName:NSStringFromClass([self class])];
}
@end
