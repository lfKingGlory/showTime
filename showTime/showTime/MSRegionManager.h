//
//  MSRegionManager.h
//  showTime
//
//  Created by msj on 16/11/9.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRegion : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableDictionary *children;
@end

@interface MSRegionManager : NSObject

+ (instancetype)shareManager;

- (NSArray<MSRegion *>*)provinces;

- (NSArray<MSRegion *>*)citiesForProvinceCode:(NSString*)provinceCode;

- (NSArray<MSRegion *>*)areasForProvinceCode:(NSString*)provinceCode cityCode:(NSString*)cityCode;

- (MSRegion*)provinceWithProvinceCode:(NSString*)provinceCode;

- (MSRegion*)cityWithProvinceCode:(NSString*)provinceCode cityCode:(NSString*)cityCode;

- (MSRegion*)areaWithProvinceCode:(NSString*)provinceCode cityCode:(NSString*)cityCode areaCode:(NSString*)areaCode;

- (NSArray<MSRegion *>*)regionForGlobalCode:(NSString*)globalCode;

- (NSString*)descriptionForGlobalCode:(NSString*)globalCode;
@end
