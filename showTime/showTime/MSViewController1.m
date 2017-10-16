//
//  MSViewController1.m
//  showTime
//
//  Created by msj on 16/8/18.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSViewController1.h"
#import "MSWaterRipple.h"
#import "MSTableViewCell1.h"
#import "UIImage+color.h"
#import "MSViewController4.h"
#import "AppDelegate.h"
#import "MSScanViewcontroller.h"
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import "MSAssetUtil.h"
//#import "MJRefresh.h"
#import "MSDelegate.h"
#import "MSIndicator.h"
#import "MSRefreshHeader.h"
#import "MSSignal.h"

#define RGB(r,g,b,a)  [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:a]

@interface MSViewController1 ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) MSWaterRipple *waterRipple;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) MSDelegate *otherDelegate;

@end

@implementation MSViewController1
- (NSString *)getTimeWithInterval:(long)interval {
    int days = (int)interval / (3600 * 24);
    interval = interval % (3600 * 24);
    int hours = (int)interval / 3600;
    interval = interval % 3600;
    int minutes = (int)interval / 60;
    int seconds = (int)interval % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", days * 24 + hours, minutes, seconds];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    {
        NSTimeInterval interval1 = 100;
        NSLog(@"%@",[self getTimeWithInterval:interval1>0 ? interval1 : 0]);
        
        NSTimeInterval interval2 = 0;
        NSLog(@"%@",[self getTimeWithInterval:interval2>0 ?: 0]);
        
        NSTimeInterval interval3 = -0.011;
        NSLog(@"%@",[self getTimeWithInterval:interval3>0 ?: 0]);
        
    }
    
    {
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        NSDictionary *sd = @{@"name" : @"liufei"};
        d[@"first"] = sd;
        NSLog(@"valueForKeyPath======%@",[d valueForKeyPath:@"first"]);
        
    }
    {
        NSNumber *n1 = @(2);
        NSNumber *n2 = @(3);
        NSNumber *n3 = nil;
        [n1 isEqualToNumber:n2];
        [n3 isEqualToNumber:n3];
    }
    
    NSLog(@"m_signal====%@",[MSSignal m_signal]);
    MSSignal *s = [MSSignal m_signal];
    s = nil;
    NSLog(@"m_signal====%@",[MSSignal m_signal]);
    
    
    self.dataArr = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        [self.dataArr addObject:@(0.2 * i)];
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.otherDelegate= [[MSDelegate alloc] init];
    self.otherDelegate.firstDelegate = self;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width,  self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self.otherDelegate;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
    
    MSIndicator *indicator = [[MSIndicator alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    indicator.backgroundColor = [UIColor redColor];
    [self.view addSubview:indicator];
    self.otherDelegate.secondDelegate = indicator;
//    self.tableView.indicator
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    tableHeaderView.backgroundColor = [UIColor orangeColor];
    self.tableView.tableHeaderView = tableHeaderView;

    self.waterRipple = [[MSWaterRipple alloc] initWithFrame:CGRectMake(0, 296, self.view.frame.size.width, 4)];
    [self.tableView.tableHeaderView addSubview:self.waterRipple];
    self.waterRipple.waterTime = 0;
    [self.waterRipple startAnimation];
    
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    self.topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.topView];
    
    __weak typeof(self) weakSelf = self;
    MSRefreshHeader *header = [MSRefreshHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
    header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = header;
    
    
    
    {
        NSMutableArray *arr = [NSMutableArray array];
        NSString *s1 = @"123";
        NSString *s2 = @"344";
        [arr addObject:s1];
        [arr addObject:s1];
        [arr addObject:s2];
        NSLog(@"before======%@",arr);
        [arr removeObjectIdenticalTo:s1];
        NSLog(@"after======%@",arr);
        
    }
    
    {
        NSMutableArray *arr = [NSMutableArray array];
        NSDictionary *dic1 = @{@"name" : @"liufei", @"age" : @"12"};
        NSDictionary *dic2 = @{@"name1" : @"liufei1", @"age" : @"23"};
        NSDictionary *dic3 = @{@"name" : @"liufei2", @"age" : @"32"};
        NSDictionary *dic4 = @{@"name" : @"liufei3", @"age" : @"43"};
        
        [arr addObject:dic1];
        [arr addObject:dic2];
        [arr addObject:dic3];
        [arr addObject:dic4];
        
        NSArray *arr1 = [arr valueForKey:@"name"];
        NSLog(@"arr1=====%@",arr1);
        
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.tabBarController.selectedIndex == 0) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.tabBarController.selectedIndex == 0) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MSTableViewCell1 alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50) style:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.progress = [self.dataArr[indexPath.row] doubleValue];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        
        
        if ([MSAssetUtil isCameraAuthority]) {
            
            MSScanViewcontroller *scanVC = [[MSScanViewcontroller alloc] init];
            [self.navigationController pushViewController:scanVC animated:YES];
        }else{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在iPhone的'设置-隐私-相机'选项中,允许APP访问你的相机" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{
        MSViewController4 *v = [[MSViewController4 alloc] init];
        //    v.fd_interactivePopDisabled = YES;
        //    v.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = 100;
        v.navigationItem.title = @"测试";
        [self.navigationController pushViewController:v animated:YES];
    }
    
//    MSViewController4 *v4 = [[MSViewController4 alloc] init];
//    v4.title = @"更多";
//    v4.tabBarItem.image = [[UIImage imageNamed:@"more_seleted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    v4.tabBarItem.selectedImage = [[UIImage imageNamed:@"more_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    MSNavigationController *nav = [[MSNavigationController alloc] initWithRootViewController:v4];
//    [self.tabBarController addChildViewController:nav];
//    
//    NSLog(@"%d===",self.tabBarController.viewControllers.count);
//    NSLog(@"%d===",self.tabBarController.tabBar.items.count);
    
//    [self.tabBarController.tabBar layoutIfNeeded];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if (contentOffsetY >= 0) {
        CGFloat scale = contentOffsetY / 100.0;
        scale = scale >= 1 ? 1: scale;
      
        self.topView.backgroundColor = RGB(51.0, 48.0, 146.0, scale);
    }else{
        self.topView.backgroundColor = [UIColor clearColor];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"MSViewController1MSViewController1MSViewController1MSViewController1");
}


@end






