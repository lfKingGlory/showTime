
//
//  MSCountDownView.m
//  showTime
//
//  Created by msj on 2016/12/20.
//  Copyright © 2016年 msj. All rights reserved.
//
#import "MSCountDownView.h"
#define RGB(r,g,b)  [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1]

@interface MSCountDownView ()
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) int count;
@end

@implementation MSCountDownView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupInit];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupInit];
    }
    return self;
}

- (void)setupInit{
    
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
    
    self.lbTitle = [[UILabel alloc] initWithFrame:self.bounds];
    self.lbTitle.font = [UIFont systemFontOfSize:15];
    self.lbTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lbTitle];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.currentMode = MSCountDownViewModeNormal;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(willCountdown)]];
}

- (void)setCurrentMode:(MSCountDownViewMode)currentMode
{
    _currentMode = currentMode;
    self.userInteractionEnabled = currentMode == MSCountDownViewModeNormal ? YES : NO;
    if (currentMode == MSCountDownViewModeNormal) {
        [self invalidate];
        self.date = nil;
        self.count = 60;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.lbTitle.textColor = RGB(233, 113, 116);
        self.lbTitle.text = @"获取验证码";
    }else if (currentMode == MSCountDownViewModeIntermediate){
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.lbTitle.textColor = RGB(233, 113, 116);
        self.lbTitle.text = @"获取中";
    }else{
        self.backgroundColor = RGB(237, 238, 239);
        self.layer.borderColor = RGB(237, 238, 239).CGColor;
        self.lbTitle.textColor = RGB(165, 166, 167);
        self.lbTitle.text = [NSString stringWithFormat:@"(%d) 秒",self.count];
        [self begin];
    }
}

- (void)begin
{
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)enterBackground
{
    if (self.currentMode == MSCountDownViewModeCountDown) {
        self.date = [NSDate date];
    }
}

- (void)enterForeground
{
    if (self.currentMode == MSCountDownViewModeCountDown) {
        int interval = (int)ceil([[NSDate date] timeIntervalSinceDate:self.date]);
        int val = self.count - interval;
        self.count = val > 0 ? val : 0;
    }
}

- (void)countDown
{
    if (self.count <= 1) {
        [self invalidate];
        self.currentMode = MSCountDownViewModeNormal;
        if (self.didEndCountdown) {
            self.didEndCountdown();
        }
    }else{
        self.count -= 1;
        self.lbTitle.text = [NSString stringWithFormat:@"(%d) 秒",self.count];
    }
}

- (void)willCountdown
{
    self.currentMode = MSCountDownViewModeIntermediate;
    if (self.willBeginCountdown) {
        self.willBeginCountdown();
    }else{
        self.currentMode = MSCountDownViewModeNormal;
    }
}

- (void)invalidate
{
    [self.timer invalidate];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
