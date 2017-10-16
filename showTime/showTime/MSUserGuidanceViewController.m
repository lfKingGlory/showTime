//
//  MSUserGuidanceViewController.m
//  showTime
//
//  Created by msj on 16/9/5.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSUserGuidanceViewController.h"
#import "MSTabBarController.h"
#import "UIView+FrameUtil.h"

@interface MSUserGuidanceViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *dataArr;
@end

@implementation MSUserGuidanceViewController

- (NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = @[@"user_guidance_01", @"user_guidance_02", @"user_guidance_03"];
    }
    return _dataArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addScrollView];
    [self addImageViews];
    
}

- (void)addScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView.contentSize = CGSizeMake(self.dataArr.count * self.scrollView.frame.size.width, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
}

- (void)addImageViews
{
    for (int i = 0; i < self.dataArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        imageView.image = [UIImage imageNamed:self.dataArr[i]];
        [self.scrollView addSubview:imageView];
        
        if (i == self.dataArr.count - 1) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.scrollView.frame.size.width - 140)/2.0, self.scrollView.frame.size.height - 100, 140, 43)];
            [btn setImage:[UIImage imageNamed:@"user_guidance_btn"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:btn];
            imageView.userInteractionEnabled = YES;
            
        }
    }
}

- (void)tap:(UIButton *)btn
{
    [[NSUserDefaults standardUserDefaults] setObject:@"mjs" forKey:[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]];
    
    MSTabBarController *tabVC = [[MSTabBarController alloc] init];
    [UIApplication sharedApplication].delegate.window.rootViewController = tabVC;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
