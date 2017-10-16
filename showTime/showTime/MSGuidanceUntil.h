//
//  MSGuidanceUntil.h
//  showTime
//
//  Created by msj on 16/8/18.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MSGuidanceUntil : NSObject
//将配置文件写入内存
+ (void)initGuidanceData;
//根据控制器类名从字典中得到引导图数组   @[home_5_1,home_5_2];
+ (NSArray *)getGuidanceDataWithClassName:(NSString *)className;
//根据控制器类名从字典中得到引导图数组   @[home_5_1,home_5_2]; 然后删掉已点击过的引导图 @[home_5_2];
+ (void)deleteGuidanceDataWithClassName:(NSString *)className;
@end


@interface MSGuidanceView : UIView
//根据控制器类名显示引导图
- (void)showWithClassName:(NSString *)className;
@end
