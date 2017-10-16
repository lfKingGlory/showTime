//
//  MSTrendChartView.h
//  showTime
//
//  Created by msj on 2017/3/20.
//  Copyright © 2017年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MSTrendChartViewMode) {
    MSTrendChartViewModeOneMonth,
    MSTrendChartViewModeThreeMonth,
    MSTrendChartViewModeSixMonth,
    MSTrendChartViewModeOneYear
};

@interface MSTrendChartView : UIView
- (void)updateWithMinTrend:(CGFloat)minTrend maxTrend:(CGFloat)maxTrend lineCount:(NSInteger)lineCount brokenLineColor:(UIColor *)brokenLineColor times:(NSArray *)times points:(NSArray *)points mask:(BOOL)mask animation:(BOOL)animation;
@property (copy, nonatomic) void (^block)(MSTrendChartViewMode mode);
@end
