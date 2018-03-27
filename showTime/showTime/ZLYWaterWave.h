//
//  ZLYWaterWeave.h
//  hulk
//
//  Created by 周凌宇 on 16/4/22.
//  Copyright © 2016年 周凌宇. All rights reserved.
//  水波工具，核心原理是创建波浪形Path，通过添加遮盖形成波浪效果

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZLYWaterWave;
@protocol ZLYWaterWaveDelegate <NSObject>
/**
 *  返回贝塞尔曲线路径
 *
 *  @param waterWave 水波工具
 *  @param path      路径
 */
- (void)waterWave:(ZLYWaterWave *)waterWave wavePath:(UIBezierPath *)path;
@end

@interface ZLYWaterWave : NSObject

- (id)initWithFrame:(CGRect)frame;

/** 水深占比，0 to 1; */
@property(nonatomic, assign)CGFloat waterDepth;

/** 波浪速度，默认 0.05f */
@property (nonatomic, assign) CGFloat speed;

/** 波浪幅度 */
@property (nonatomic, assign) CGFloat amplitude;

/** 波浪紧凑程度（角速度），默认 1.0 */
@property (nonatomic, assign) CGFloat angularVelocity;

/**
 开始波动
 */
- (void)startAnimation;

/**
 停止波动
 */
- (void)stopAnimation;

/** 代理 */
@property (nonatomic, weak) id<ZLYWaterWaveDelegate> delegate;

@end
