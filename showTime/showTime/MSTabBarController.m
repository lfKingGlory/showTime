//
//  MSTabBarController.m
//  showTime
//
//  Created by msj on 16/8/18.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSTabBarController.h"
#import "MSNavigationController.h"
#import "MSViewController1.h"
#import "MSViewController2.h"
#import "MSViewController3.h"
#import "MSViewController4.h"
#import "MSTabBar.h"

@interface MSTabBarController ()<UITabBarControllerDelegate>
@property (assign, nonatomic) NSInteger indexFlag;
@end

@implementation MSTabBarController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    __block NSArray *arr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"vc.plist" ofType:nil];
        arr = [NSArray arrayWithContentsOfFile:path];
    });
    
    if (arr && arr.count > 0) {
        for (NSDictionary *dic in arr) {
            UIViewController *vc = [[NSClassFromString(dic[@"vcName"]) alloc] init];
            [self addViewController:vc image:dic[@"image"] seletedImage:dic[@"selectedImage"] title:dic[@"title"]];
        }
    } else {
        MSViewController1 *v1 = [[MSViewController1 alloc] init];
        [self addViewController:v1 image:@"home_normal" seletedImage:@"home_seleted" title:@"首页"];
        
        MSViewController2 *v2 = [[MSViewController2 alloc] init];
        [self addViewController:v2 image:@"account_normal" seletedImage:@"account_seleted" title:@"账户"];
    }

    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:218.0/256.0 green:55.0/256.0 blue:49.0/256.0 alpha:1.0]];
    
//    self.delegate = self;
//    [self setValue:[[MSTabBar alloc] init] forKeyPath:@"tabBar"];
    [UITabBar appearance].itemPositioning = UITabBarItemPositioningCentered;
}

- (void)addViewController:(UIViewController *)viewController image:(NSString *)image seletedImage:(NSString *)seletedImage title:(NSString *)title
{
    viewController.title = title;
    viewController.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:seletedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MSNavigationController *nav = [[MSNavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:nav];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {

    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    if (self.indexFlag != index) {
        [self animationWithIndex:index];
    }
    
    MSViewController4 *v4 = [[MSViewController4 alloc] init];
    [self addViewController:v4 image:@"more_normal" seletedImage:@"more_seleted" title:@"更多"];
    
    NSLog(@"%lu====",self.tabBar.items.count);
    
    [self.tabBar layoutIfNeeded];
}

- (void)animationWithIndex:(NSInteger) index {
    
    self.indexFlag = index;
    
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            for (UIView *sb in tabBarButton.subviews) {
                if ([sb isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                    [tabbarbuttonArray addObject:sb];
                }
            }
            
            
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.duration = 0.15;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.8];
    pulse.toValue= [NSNumber numberWithFloat:1.2];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
}

@end
