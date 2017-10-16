//
//  MSUserGuideView.h
//  mvvm+rac
//
//  Created by msj on 2017/3/13.
//  Copyright © 2017年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSUserGuideView : UIWindow
- (void)show;
- (void)dismiss;
@end

/*
 if (![[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]) {
 //进入引导页
 self.v = [[MSUserGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
 [self.v show];
 }
 
 
 [[NSUserDefaults standardUserDefaults] setObject:@"ms_user_guide" forKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
 */
