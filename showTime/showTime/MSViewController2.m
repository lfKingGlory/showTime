//
//  MSViewController2.m
//  showTime
//
//  Created by msj on 16/8/18.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSViewController2.h"
#import "MSWaterRipple.h"
#import "MSLoadingView.h"
#import "MSTextView.h"
#import "UIView+FrameUtil.h"
#import "AppDelegate.h"
#import "MSGestureView.h"
#import "MSPhotoController.h"
#import "MSPhotoItem.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SDImageCache.h"

@interface MSViewController2 ()<MSGestureViewDelegate, UITextViewDelegate>
@property (assign, nonatomic) BOOL statusBarStyleControl;
@property (strong, nonatomic) MSLoadingView *loadingView;
@property (strong, nonatomic) MSLoadingView *loadingView1;
@property (strong, nonatomic) NSTimer *time;
@property (strong, nonatomic) MSGestureView *gesView;
@property (nonatomic, strong) NSArray *srcStringArray;
@property (strong, nonatomic) MSTextView *textView;

@end

@implementation MSViewController2
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    NSLog(@"%@",[AppDelegate shareInstance].navigationController.viewControllers);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.statusBarStyleControl = YES;

    
    MSTextView *textView = [[MSTextView alloc] initWithFrame:CGRectMake(20, 100, self.view.width - 40, 100)];
    textView.backgroundColor = [UIColor orangeColor];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:textView];
    textView.placeholderFont = [UIFont systemFontOfSize:17];
    textView.placeholder = @"检查拉查拉际";
    
    self.textView = textView;
    
    
    self.gesView = [[MSGestureView alloc] initWithFrame:CGRectMake(50, 220, self.view.frame.size.width - 100, self.view.frame.size.width - 100)];
    self.gesView.delegate = self;
    [self.view addSubview:self.gesView];
    
    _srcStringArray = @[
                        @"http://ww2.sinaimg.cn/bmiddle/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                        @"http://ww2.sinaimg.cn/bmiddle/642beb18gw1ep3629gfm0g206o050b2a.gif",
                        @"http://ww4.sinaimg.cn/bmiddle/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg",
                        @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                        @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                        @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                        @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
                        @"http://ww2.sinaimg.cn/bmiddle/677febf5gw1erma104rhyj20k03dz16y.jpg",
                        @"http://ww4.sinaimg.cn/bmiddle/677febf5gw1erma1g5xd0j20k0esa7wj.jpg"
                        ];
    
//    UIView *flipView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300)];
//    flipView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:flipView];
    
//    {
//        CAShapeLayer *mask = [CAShapeLayer layer];
//        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((flipView.frame.size.width - 100)/2.0, (flipView.frame.size.height - 100)/2.0, 100, 120)];
//        mask.path = path.CGPath;
//        flipView.layer.mask = mask;
//    }
    
//    {
//        flipView.layer.geometryFlipped = YES;
//        
//        UIView *flipView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        flipView1.backgroundColor = [UIColor yellowColor];
//        [flipView addSubview:flipView1];
//        flipView1.layer.geometryFlipped = YES;
//        
//        UIView *flipView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        flipView2.backgroundColor = [UIColor blueColor];
//        [flipView1 addSubview:flipView2];
//        
//        UIView *flipView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
//        flipView3.backgroundColor = [UIColor orangeColor];
//        [flipView2 addSubview:flipView3];
//
//    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSLog(@"replacementText=====%@",text);
    NSLog(@"shouldChangeTextInRange=====%@",NSStringFromRange(range));
    
    return YES;
}

- (NSString *)filterEmoji:(NSString *)text
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@""];
    return modifiedString;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *text = [self filterEmoji:textView.text];
    textView.text = text;
    NSLog(@"textViewDidChange===========%@",textView.text);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    MSPhotoController *vc = [[MSPhotoController alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.srcStringArray.count; i++) {
        MSPhotoItem *item = [[MSPhotoItem alloc] init];
        item.thumbnail_pic = self.srcStringArray[i];
        [arr addObject:item];
    }
    vc.photoItems = arr;
    vc.currentIndex = 3;
    [[UIApplication sharedApplication].delegate.window addSubview:vc];

    if (!self.time) {
        self.loadingView.alpha = 1;
        self.loadingView1.alpha = 1;
        [self start];
    }


    self.statusBarStyleControl = !self.statusBarStyleControl;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)ms_gestureView:(MSGestureView *)gestureView didSelectedPassword:(NSString *)passWord
{
    NSLog(@"%@",passWord);
    if ([passWord isEqualToString:@"1245"]) {
        self.gesView.gestureViewType = MSGestureView_normal;
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
    }else{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        self.gesView.gestureViewType = MSGestureView_error;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             self.gesView.gestureViewType = MSGestureView_normal;
        });
    }
}

- (void)start
{
    self.time = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(run) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.time forMode:NSRunLoopCommonModes];
}

- (void)run
{
    if (self.loadingView.progress >= 1) {
        [self.time invalidate];
        self.time = nil;
        [UIView animateWithDuration:0.3 animations:^{
            self.loadingView.alpha = 0;
            self.loadingView1.alpha = 0;
        } completion:^(BOOL finished) {
            self.loadingView.progress = 0;
            self.loadingView1.progress = 0;
        }];
    }else{
        self.loadingView.progress += 0.05;
        self.loadingView1.progress += 0.05;
    }
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.statusBarStyleControl) {
        return UIStatusBarStyleDefault;
    }else{
        return UIStatusBarStyleLightContent;
    }
}
@end
