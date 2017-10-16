//
//  MSGuidanceUntil.m
//  showTime
//
//  Created by msj on 16/8/18.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSGuidanceUntil.h"
#define  PATH  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"GuidanceData.strings"]
#define  SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height

#pragma mark - MSGuidanceUntil
@implementation MSGuidanceUntil
+ (void)initGuidanceData{
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"GuidanceData" ofType:@"strings"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    [dic writeToFile:PATH atomically:YES];
    
}

+ (NSArray *)getGuidanceDataWithClassName:(NSString *)className{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:PATH];
    NSString *realClassName = [self convertScreen:className];
    NSString *dataStr = dic[realClassName];
    if (dataStr) {
        return [dataStr componentsSeparatedByString:@","];
    }else{
        return nil;
    }
    
}

+ (void)deleteGuidanceDataWithClassName:(NSString *)className{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:PATH];
    NSString *realClassName = [self convertScreen:className];
    [dic removeObjectForKey:realClassName];
    [dic writeToFile:PATH atomically:YES];
    
}

+ (NSString *)convertScreen:(NSString *)className{
    
    if (SCREENHEIGHT >= 736) {
        return [NSString stringWithFormat:@"%@_6p",className];
    }else if (SCREENHEIGHT >= 667){
        return [NSString stringWithFormat:@"%@_6",className];
    }else if (SCREENHEIGHT >= 568){
        return [NSString stringWithFormat:@"%@_5",className];
    }else{
        return [NSString stringWithFormat:@"%@_4",className];
    }
}
@end


#pragma mark - MSGuidanceView
@interface MSGuidanceView ()
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSArray *dataArr;
@property (strong, nonatomic) NSString *className;
@end

@implementation MSGuidanceView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        self.index = 0;
    }
    return self;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.userInteractionEnabled = YES;
        _imageView.image = [UIImage imageNamed:self.dataArr[self.index]];
        [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    }
    return _imageView;
}

- (void)tap
{
    if (self.index >= self.dataArr.count - 1) {
        [MSGuidanceUntil deleteGuidanceDataWithClassName:self.className];
        [self removeFromSuperview];
    }else{
        self.imageView.image = [UIImage imageNamed:self.dataArr[++self.index]];
    }
}

- (void)showWithClassName:(NSString *)className
{
    self.dataArr = [MSGuidanceUntil getGuidanceDataWithClassName:className];
    if (!self.dataArr)  return;
    self.className = className;
    [self addSubview:self.imageView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

@end








