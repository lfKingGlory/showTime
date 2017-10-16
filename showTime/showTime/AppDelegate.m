//
//  AppDelegate.m
//  showTime
//
//  Created by msj on 16/8/18.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "AppDelegate.h"
#import "MSTabBarController.h"
#import "MSGuidanceUntil.h"
#import "MSUserGuidanceViewController.h"
#import "MSUserGuideView.h"

@interface AppDelegate ()
@property (strong, nonatomic) MSUserGuideView *userGuideView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //通过判断版本号是否存储过来 判断是否是最新版本，就将.string文件写入内存
    if (![[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]) {
        [MSGuidanceUntil initGuidanceData];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MSTabBarController *tabVC = [[MSTabBarController alloc] init];
    self.window.rootViewController = tabVC;
    [self.window makeKeyAndVisible];

    return YES;
}
@end
