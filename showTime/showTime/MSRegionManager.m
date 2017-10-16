//
//  MSRegionManager.m
//  mobip2p
//
//  Created by Guo Yu on 14/11/28.
//  Copyright (c) 2014年 zkbc. All rights reserved.
//

#import "MSRegionManager.h"
#import "FMDB.h"

@interface MSRegion()
@end

@implementation MSRegion

- (BOOL)isEqual:(MSRegion*)object {
    return [self.code isEqualToString:object.code];
}

@end

@interface MSRegionManager()
@property (nonatomic, strong) NSMutableDictionary *provinceDictionary;
@end

@implementation MSRegionManager

+ (instancetype)shareManager
{
    static MSRegionManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MSRegionManager alloc] init];
    });
    
    [manager loadData];
    
    return manager;
}

- (void)loadData
{
    if (self.provinceDictionary) {
        return;
    }
    
    NSString *dbPath = [[NSBundle mainBundle]pathForResource:@"china_area.sqlite3" ofType:nil];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return;
    }
    
    self.provinceDictionary = [NSMutableDictionary new];
    
    //一级行政单位
    FMResultSet *provinceSet = [db executeQuery:@"select * from ZC_prov"];
    while ([provinceSet next]) {
        MSRegion *province = [MSRegion new];
        province.code = [[provinceSet stringForColumn:@"code"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        province.name = [[provinceSet stringForColumn:@"nam"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        province.children = [NSMutableDictionary new];
        self.provinceDictionary[province.code] = province;
    }
    
    //二级单位
    NSMutableDictionary *fastAccesCity = [NSMutableDictionary new];
    for (NSString *provinceCode in [self.provinceDictionary allKeys]) {
        MSRegion *province = self.provinceDictionary[provinceCode];
        
        FMResultSet *citySet = [db executeQuery:[NSString stringWithFormat:@"select * from ZC_city where provCode = '%@'",provinceCode]];
        
        while ([citySet next]) {
            MSRegion *city = [MSRegion new];
            city.code = [[citySet stringForColumn:@"code"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            city.name = [[citySet stringForColumn:@"nam"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            city.children = [NSMutableDictionary new];
            province.children[city.code] = city;
            
            fastAccesCity[city.code] = city;
        }
    }
    
    // 三级单位
    for (NSString *cityCode in [fastAccesCity allKeys]) {
        MSRegion *city = fastAccesCity[cityCode];
        
        FMResultSet *distrSet = [db executeQuery:[NSString stringWithFormat:@"select * from area where citycode = '%@'",[NSString stringWithFormat:@"%@00",cityCode]]];
        
        while ([distrSet next]) {
            MSRegion *distr = [MSRegion new];
            distr.code = [[distrSet stringForColumn:@"code"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            distr.name = [[distrSet stringForColumn:@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            city.children[distr.code] = distr;
        }
    }
    
    [db close];
}

- (NSArray<MSRegion *> *)provinces {
    
    return [self.provinceDictionary allValues];
}

- (NSArray<MSRegion *> *)citiesForProvinceCode:(NSString*)provinceCode {
    MSRegion *province = self.provinceDictionary[provinceCode];
    if (province) {
        return [province.children allValues];
    }
    return nil;
}

- (NSArray<MSRegion *> *)areasForProvinceCode:(NSString*)provinceCode cityCode:(NSString*)cityCode {
    MSRegion *province = self.provinceDictionary[provinceCode];
    if (province) {
        MSRegion *city = province.children[cityCode];
        if (city) {
            return [city.children allValues];
        }
    }
    return nil;
}

- (MSRegion*)provinceWithProvinceCode:(NSString*)provinceCode {
    return self.provinceDictionary[provinceCode];
}

- (MSRegion*)cityWithProvinceCode:(NSString*)provinceCode cityCode:(NSString*)cityCode {
    MSRegion *province = self.provinceDictionary[provinceCode];
    return province.children[cityCode];
}

- (MSRegion*)areaWithProvinceCode:(NSString*)provinceCode cityCode:(NSString*)cityCode areaCode:(NSString*)areaCode {
    MSRegion *province = self.provinceDictionary[provinceCode];
    MSRegion *city = province.children[cityCode];
    return city.children[areaCode];
}

- (NSArray<MSRegion *> *)regionForGlobalCode:(NSString*)globalCode {
    if (globalCode.length != 6) {
        return nil;
    }
    
    NSMutableString *likeText = [NSMutableString stringWithString:globalCode];
    NSRange range = {2, 4};
    NSMutableArray *regions = [NSMutableArray new];
    
    [likeText replaceCharactersInRange:range withString:@"0000"];
    
    MSRegion *province = self.provinceDictionary[likeText];
    if (nil == province) {
        return nil;
    }
    [regions addObject:province];
    
    range = (NSRange){2, 2};
    if ([[globalCode substringWithRange:range] isEqualToString:@"00"]) {
        return regions;
    }
    likeText.string = globalCode;
    range = (NSRange){4, 2};
    [likeText replaceCharactersInRange:range withString:@"00"];
    MSRegion *city = province.children[likeText];
    if (nil == city) {
        return regions;
    }
    [regions addObject:city];
    
    range = (NSRange){4, 2};
    if ([[globalCode substringWithRange:range] isEqualToString:@"00"]) {
        return regions;
    }
    MSRegion *distr = city.children[globalCode];
    if (nil == distr) {
        return regions;
    }
    [regions addObject:distr];
    
    return regions;
}

- (NSString*)descriptionForGlobalCode:(NSString*)globalCode {
    NSArray *regions = [self regionForGlobalCode:globalCode];
    
    NSMutableString *res = [NSMutableString new];
    for (MSRegion *r in regions) {
        [res appendString:r.name];
        [res appendString:@" "];
    }
    
    return res;
}

@end
