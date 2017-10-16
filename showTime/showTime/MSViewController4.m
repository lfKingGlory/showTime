//
//  MSViewController4.m
//  showTime
//
//  Created by msj on 16/8/18.
//  Copyright © 2016年 msj. All rights reserved.
//
#import <objc/runtime.h>
#import "MSViewController4.h"
#import "MSProgressView.h"
#import "UIImage+color.h"
#import "MSScrollView.h"
#import "PureLayout.h"
#import "MSFileDownLoader.h"
#import "UIView+FrameUtil.h"
#import "MSLoadingView.h"
#import "MSPhotoSelectorController.h"
#import "MSNavigationController.h"
#import "MSCardViewController.h"
#import "MSUserGuidanceViewController.h"
#import "MSBubbleTransition.h"

#import "pop.h"
#import "MSRegionManager.h"
#import "MSPinView.h"
#import "MSCountDownView.h"
#import "MSPinLoadingView.h"
#import "MSTradePasswordView.h"
#import "MSVerificationCodeView.h"
#import "UIColor+StringColor.h"
#import "MSAlertController.h"
#import "UIImageView+WebCache.h"
#import "UIGestureRecognizer+YYAdd.h"
#import "UIControl+YYAdd.h"
#import "UIBarButtonItem+YYAdd.h"

#import "MSChanneiModel.h"
#import "MSChannelCell.h"
#import "MSQRCodeGenerator.h"
#import "MSTrendChartView.h"
#import "MSDrawLine.h"
#import "MSProgressBar.h"
#import "NSDate+YYAdd.h"

#define RGB(r,g,b)  [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1]


@interface MSViewController4 ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) MSLoadingView *loadingView;
//@property (strong, nonatomic) UIWebView *webview;
@property (strong, nonatomic) MSScrollView *scrollView;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *btnAdd;
@property (strong, nonatomic) MSBubbleTransition *transition;

@property (strong, nonatomic) UIWebView *webveiw;
@property (strong, nonatomic) MSPinView *pinView;
@property (strong, nonatomic) UITextField *tf;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) int countDown;

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) MSCountDownView *countDownView;
@property (assign, nonatomic) BOOL isSuccess;

@property (strong, nonatomic) MSPinLoadingView *pinLoadingView;
@property (strong, nonatomic) MSTradePasswordView *tradePasswordView;

@property (strong, nonatomic) MSVerificationCodeView *codeView;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *channels;
@property (strong, nonatomic) MSTrendChartView *trendChartView;

@property (strong, nonatomic) UILabel *lb;
@property (strong, nonatomic) UILabel *lbRed;
@property (strong, nonatomic) UILabel *lbRed2;
@property (strong, nonatomic) NSLayoutConstraint *lbConstraint;
@property (strong, nonatomic) MSProgressBar *bar1;


@end

@implementation MSViewController4

- (NSMutableArray *)channels
{
    if (!_channels) {
        _channels = [NSMutableArray array];
        
        NSArray *arr = @[@"头条",@"娱乐",@"体育",@"热点",@"社会",@"财经",@"科技",@"图片",@"汽车",@"军事",@"历史",@"涨知识"];
        
        for (int i = 0; i < arr.count; i++) {
            MSChanneiModel *model = [[MSChanneiModel alloc] init];
            model.title = arr[i];
            model.isSelected = (i == 0) ? YES : NO;
            [_channels addObject:model];
        }
        
    }
    return _channels;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.lbConstraint autoRemove];
    self.bar1.progress = arc4random()%100+1;
    if (self.lbRed.hidden) {
        self.lbRed.hidden = NO;
        self.lbConstraint = [self.lbRed2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lbRed withOffset:5];
        self.lb.text = @"出售出售窗口我";
    }else{
        self.lbRed.hidden = YES;
        self.lbConstraint = [self.lbRed2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lb withOffset:5];
        self.lb.text = @"出售窗口出售窗口出售窗口出售窗口出售窗口出售窗口出售窗口出售窗口出售窗口出售窗口我";
    }
    
    
    [MSAssetUtil requestAuthorizationSuccess:^{
        
        __weak typeof(self) weakSelf = self;
        MSPhotoSelectorController *vc = [[MSPhotoSelectorController alloc] init];
        vc.callBlack = ^(UIImage *image){
            weakSelf.imageView.image = image;
        };
        MSNavigationController *nav = [[MSNavigationController alloc] initWithRootViewController:vc];
        
        [self.navigationController presentViewController:nav animated:YES completion:^{
            
        }];
        
        
    } faliure:^{
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"在iPhone的\"设置-隐私-相册\"中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 30)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
//    NSArray *arr = @[NSStringFromCGPoint(CGPointMake(10, 80)),
//                     NSStringFromCGPoint(CGPointMake(90, 80)),
//                     NSStringFromCGPoint(CGPointMake(90, 160)),
//                     NSStringFromCGPoint(CGPointMake(10, 160)),
//                     NSStringFromCGPoint(CGPointMake(10, 80))];
    
    NSArray *arr = @[NSStringFromCGPoint(CGPointMake(0, 15)),
                     NSStringFromCGPoint(CGPointMake(view1.frame.size.width, 15))];

    CALayer *layer = [MSDrawLine drawDotLineWidth:4 lineSpace:4 lineColor:RGB(248,227,214) points:arr];
    [view1.layer addSublayer:layer];
    
    NSArray *arr1 = @[NSStringFromCGPoint(CGPointMake(0, 10)),
            NSStringFromCGPoint(CGPointMake(view1.frame.size.width, 10))];
    CALayer *layer1 = [MSDrawLine drawSolidLineWidth:0.5 lineColor:RGB(206,206,206) points:arr1];
    [view1.layer addSublayer:layer1];
    
    UILabel *lb = [UILabel newAutoLayoutView];
    [view1 addSubview:lb];
    [lb autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [lb autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [lb autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [lb autoSetDimension:ALDimensionWidth toSize:view1.size.width - 130 relation:NSLayoutRelationLessThanOrEqual];
    lb.backgroundColor = [UIColor orangeColor];
    lb.text = @"凝聚斯囧事";
    self.lb = lb;
    
    
    UILabel *lbRed = [[UILabel alloc] init];
    lbRed.textColor = [UIColor redColor];
    lbRed.textAlignment = NSTextAlignmentCenter;
    lbRed.font = [UIFont systemFontOfSize:13];
    lbRed.layer.borderWidth = 0.5;
    lbRed.layer.borderColor = [UIColor redColor].CGColor;
    lbRed.layer.cornerRadius = 2;
    [view1 addSubview:lbRed];
    [lbRed autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [lbRed autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [lbRed autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lb withOffset:5];
    lbRed.text = @"红包1";
    self.lbRed = lbRed;
    
    self.lbRed2 = [[UILabel alloc] init];
    self.lbRed2.textColor = [UIColor redColor];
    self.lbRed2.textAlignment = NSTextAlignmentCenter;
    self.lbRed2.font = [UIFont systemFontOfSize:13];
    self.lbRed2.layer.borderWidth = 0.5;
    self.lbRed2.layer.borderColor = [UIColor redColor].CGColor;
    self.lbRed2.layer.cornerRadius = 2;
    [view1 addSubview:self.lbRed2];
    [self.lbRed2 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.lbRed2 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    self.lbConstraint = [self.lbRed2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lbRed withOffset:5];
    self.lbRed2.text = @"红包2";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(60, 45);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 300, self.view.width, 45) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[MSChannelCell class] forCellWithReuseIdentifier:@"MSChannelCell"];
    
    CGFloat size = 120;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - size)/2.0, 100, size, size)];
    self.imageView.layer.shadowOffset = CGSizeMake(0, 0.5);  // 设置阴影的偏移量
    self.imageView.layer.shadowRadius = 1;  // 设置阴影的半径
    self.imageView.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
    self.imageView.layer.shadowOpacity = 0.3; // 设置阴影的不透明度
    [self.view addSubview:self.imageView];
    
    self.imageView.image = [MSQRCodeGenerator ms_creatQRCodeWithMessage:@"http://www.jianshu.com/p/05949cc8f7af" logo:[UIImage imageNamed:@"ios_80"]];
    
    
//    CIImage *ciimage1 = [CIImage imageWithCGImage:self.imageView.image.CGImage];
//    
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [filter setDefaults];
//    [filter setValue:ciimage1 forKeyPath:@"inputImage"];
//    [filter setValue:@20 forKeyPath:@"inputRadius"];
//    CIImage *ciImage = filter.outputImage;
//    CGRect extentRect = CGRectIntegral(ciImage.extent);
//    CGFloat scale = MIN(size / CGRectGetWidth(extentRect), size / CGRectGetHeight(extentRect));
//    
//    size_t width = CGRectGetWidth(extentRect) * scale;
//    size_t height = CGRectGetHeight(extentRect) * scale;
//    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
//    CGContextRef bitmapRef = CGBitmapContextCreate(NULL, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//    
//    CIContext *context = [CIContext contextWithOptions:nil];
//    
//    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extentRect];
//    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
//    CGContextScaleCTM(bitmapRef, scale, scale);
//    CGContextDrawImage(bitmapRef, extentRect, bitmapImage);
//    
//    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
//    CGContextRelease(bitmapRef);
//    CGImageRelease(bitmapImage);
//    
//    self.imageView.image = [UIImage imageWithCGImage:scaledImage];
    
    
    
    
    
    
    
    
//    [self showAllFilters];
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    NSLog(@"%@",filter.inputKeys);
//    NSLog(@"%@",filter.outputKeys);
    //CICode128BarcodeGenerator   CIPDF417BarcodeGenerator
    
    
    
    NSMutableArray *times = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        NSUInteger count = 4 + i;
        NSString *time = [NSString stringWithFormat:@"02-%02lu",(unsigned long)count];
        [times addObject:time];
    }
    
    self.view.backgroundColor = RGB(206,206,206);
    
    self.trendChartView = [[MSTrendChartView alloc] initWithFrame:CGRectMake(0, 250, self.view.width, 260)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.trendChartView updateWithMinTrend:-0.0936 maxTrend:3.5963 lineCount:3 brokenLineColor:RGB(249, 217, 189) times:times points:[self points] mask:YES animation:NO];
    });
    __weak typeof(self) weakSelf = self;
    self.trendChartView.block = ^(MSTrendChartViewMode mode){
        __strong typeof(weakSelf) self = weakSelf;
        [self.trendChartView updateWithMinTrend:0.0936 maxTrend:3.5963 lineCount:5 brokenLineColor:RGB(249, 217, 189) times:times points:[self points] mask:(mode<2) animation:YES];
    };
//    [self.view addSubview:self.trendChartView];
    
//    [self setup];
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(100, 100, 100, 100)];
//    CAShapeLayer *l = [CAShapeLayer layer];
//    l.strokeColor = [UIColor clearColor].CGColor;
//    l.fillColor = RGB(249, 217, 189).CGColor;
//    l.opacity = 0.3;
//    l.path = path.CGPath;
//    [self.trendChartView.layer addSublayer:l];
    
//    MSProgressBar *bar1 = [MSProgressBar newAutoLayoutView];
//    [self.trendChartView addSubview:bar1];
//    [bar1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
//    [bar1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
//    [bar1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:80];
//    [bar1 autoSetDimension:ALDimensionHeight toSize:2];
//    bar1.progress = 45;
//    self.bar1 = bar1;
    
    
//    [self.trendChartView.layer addSublayer:layer];
    
//    NSString *pattern = @"";
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
//    NSTextCheckingResult *result;
//    result = [regex firstMatchInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
//    if (result == nil) {
//        return false;
//    }
//    return true;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1491355774];
    
    NSLog(@"year===%ld",(long)date.year);
    NSLog(@"month===%ld",(long)date.month);
    NSLog(@"day===%ld",(long)date.day);
    NSLog(@"hour===%ld",(long)date.hour);
    NSLog(@"minute===%ld",(long)date.minute);
    NSLog(@"second===%ld",(long)date.second);
    
    {
        UIView *view11 = [[UIView alloc] initWithFrame:CGRectMake(25, 400, self.view.frame.size.width - 50, 40)];
        view11.backgroundColor= [UIColor whiteColor];
        view11.layer.cornerRadius = 5;
        [self.view addSubview:view11];
        CGRect frame = CGRectMake(20, 0, 110, 40);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"Hello World";
        label.textAlignment = NSTextAlignmentCenter;
        [view11 addSubview:label];
        view11.alpha = 0.5;
        view11.layer.shouldRasterize = YES;
        view11.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    
}

- (void)setup
{
    UIView *testView=[[UIView alloc] initWithFrame:CGRectMake(30, 300, 100, 100)];
    [self.view addSubview:testView];
    
    testView.layer.backgroundColor = [UIColor clearColor].CGColor;
    CAShapeLayer *pulseLayer = [CAShapeLayer layer];
    pulseLayer.frame = testView.layer.bounds;
    pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer.bounds].CGPath;
    pulseLayer.fillColor = [UIColor redColor].CGColor;//填充色
    pulseLayer.opacity = 0.0;
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = testView.bounds;
    replicatorLayer.instanceCount = 4;//创建副本的数量,包括源对象。
    replicatorLayer.instanceDelay = 1;//复制副本之间的延迟
    [replicatorLayer addSublayer:pulseLayer];
    
    [testView.layer addSublayer:replicatorLayer];
    
    CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnima.fromValue = @(0.3);
    opacityAnima.toValue = @(0.0);
    
    CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[opacityAnima, scaleAnima];
    groupAnima.duration = 4.0;
    groupAnima.autoreverses = NO;
    groupAnima.repeatCount = HUGE;
    [pulseLayer addAnimation:groupAnima forKey:@"groupAnimation"];
}

- (NSArray *) points {
    NSMutableArray *points = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        CGFloat a = (arc4random() % 10000)*1.0/5001 + 1;
        NSLog(@"%lf",a);
        [points addObject:@(a)];
    }
    return points;
}

-(void)showAllFilters{
    NSArray *filterNames=[CIFilter filterNamesInCategory:kCICategoryGenerator];
    for (NSString *filterName in filterNames) {
        CIFilter *filter=[CIFilter filterWithName:filterName];
        NSLog(@"\rfilter:%@\rattributes:%@",filterName,[filter attributes]);
    }
}




- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@",NSStringFromCGRect(self.collectionView.frame));
    NSLog(@"%@",NSStringFromCGSize(self.collectionView.contentSize));
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)self.channels.count);
    return self.channels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSChannelCell" forIndexPath:indexPath];
    cell.model = self.channels[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"collectionView");
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [MSAssetUtil requestAuthorizationSuccess:^{
//        
//        
//        __weak typeof(self) weakSelf = self;
//        MSPhotoSelectorController *vc = [[MSPhotoSelectorController alloc] init];
//        vc.callBlack = ^(UIImage *image){
//            weakSelf.imageView.image = image;
//        };
//        MSNavigationController *nav = [[MSNavigationController alloc] initWithRootViewController:vc];
//        
//        [self.navigationController presentViewController:nav animated:YES completion:^{
//            
//        }];
//        
//        
//    } faliure:^{
//        
//        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"在iPhone的\"设置-隐私-相册\"中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }];
//        [alert addAction:action];
//        
//        [self presentViewController:alert animated:YES completion:nil];
//    }];
//
//    
//}

@end


    //    self.navigationController.interactivePopGestureRecognizer.delegate = self;

//    UIPresentationController

//    POPAnimatableProperty *ani = [POPAnimatableProperty propertyWithName:<#(NSString *)#> initializer:<#^(POPMutableAnimatableProperty *prop)block#>]
    
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    
//    self.scrollView = [[MSScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.width * 590.f / 1080.f)];
//    
//    [self.view addSubview:self.scrollView];
//    
//    self.scrollView.urlArray = @[
//                                 @"https://www.mjsfax.com:6101/util/getPic?filePath=/mjs/mbanner/3567b885-d3e6-4528-bee3-7e8e863e5484.jpg",
//                                 @"https://www.mjsfax.com:6101/util/getPic?filePath=/mjs/mbanner/0b891554-f02a-4308-8f05-0e942384d6cf.jpg",
//                                 @"https://www.mjsfax.com:6101/util/getPic?filePath=/mjs/mbanner/7a91ceed-cae9-4bf6-8ae5-f178275a0507.jpg"
//                                 ];

    
//    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    self.imageView.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleAspectFill
//    self.imageView.center = self.view.center;
//    self.imageView.layer.cornerRadius = 50;
//    self.imageView.clipsToBounds = YES;
//    [self.view addSubview:self.imageView];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show:) name:UIKeyboardWillShowNotification object:nil];
//    
//    self.btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(30, self.view.height - 120, 60, 60)];
//    self.btnAdd.backgroundColor = [UIColor colorWithRed:158.0/256.0 green:68.0/256.0 blue:67.0/256.0 alpha:1];
//    [self.btnAdd setTitle:@"+" forState:UIControlStateNormal];
//    [self.btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.btnAdd.titleLabel.font = [UIFont systemFontOfSize:25];
//    self.btnAdd.layer.cornerRadius = 30;
//    self.btnAdd.layer.masksToBounds = YES;
//    [self.view addSubview:self.btnAdd];
//    
//    [self.btnAdd addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
//    
//    __weak typeof(self)weakSelf = self;
//    
//    self.tradePasswordView = [[MSTradePasswordView alloc] initWithFrame:CGRectMake(0, 70, self.view.width, 234)];
//    self.tradePasswordView.protocolName = @"提现协议充值协议";
//    self.tradePasswordView.money = @"提现500元";
////    self.tradePasswordView.isHideProtocol = YES;
//    
//    self.pinLoadingView = [[MSPinLoadingView alloc] initWithFrame:self.tradePasswordView.frame];
//    
//    self.codeView = [[MSVerificationCodeView alloc] initWithFrame:self.tradePasswordView.frame];
//    self.codeView.cancelBlock = ^{
//        NSLog(@"cancelBlock");
//    };
//    self.codeView.getVerificationCodeBlock = ^{
//         NSLog(@"getVerificationCodeBlock");
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf.codeView beginCountDown];
//        });
//    };
//    self.codeView.makeSureBlock = ^(NSString *verificationCode){
//        NSLog(@"verificationCode==%@",verificationCode);
//    };
//    self.codeView.phoneNumber = @"3465";
//    
//    
//    self.tradePasswordView.finishBlock = ^(NSString *password){
//        NSLog(@"%@",password);
//        [weakSelf.view addSubview:weakSelf.pinLoadingView];
//        [weakSelf.pinLoadingView becomeFirstResponder];
//        [weakSelf.tradePasswordView reset];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            [weakSelf.tradePasswordView becomeFirstResponder];
////            weakSelf.tradePasswordView.isPasswordSuccess = NO;
//            [weakSelf.view addSubview:weakSelf.codeView];
//            [weakSelf.codeView becomeFirstResponder];
//            [weakSelf.codeView beginCountDown];
//            [weakSelf.pinLoadingView removeFromSuperview];
//        });
//    };
//    self.tradePasswordView.lookProtocolBlock = ^{
//        NSLog(@"lookProtocolBlock");
//    };
//    
//    self.tradePasswordView.forgetPasswordBlock = ^{
//        NSLog(@"forgetPasswordBlock");
//    };
//    
//    self.tradePasswordView.cancelBlock = ^{
//        NSLog(@"cancelBlock");
//    };
//    
//    [self.tradePasswordView becomeFirstResponder];
//    [self.view addSubview:self.tradePasswordView];
//    
//    
//    
//    
//    
//    self.countDownView = [[MSCountDownView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 110)/2.0, 300, 110, 40)];
//    self.countDownView.willBeginCountdown = ^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            weakSelf.countDownView.currentMode = weakSelf.isSuccess ? MSCountDownViewModeCountDown : MSCountDownViewModeNormal;
//            weakSelf.isSuccess = !weakSelf.isSuccess;
//        });
//    };
//    [self.view addSubview:self.countDownView];
//    
    
    
//    [self showAllFilters];
    
    
//    UIView *view1 = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    view1.backgroundColor = [UIColor orangeColor];
//    [self.navigationController.viewControllers addSubview:view1];
    
//    UILabel *lbTest = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.width - 40, 0)];
//    [self.view addSubview:lbTest];
//    lbTest.font = [UIFont systemFontOfSize:14];
//    lbTest.numberOfLines = 0;
//    lbTest.backgroundColor = [UIColor orangeColor];
//    
//    NSString *test = @"这一次，我们拥有比往常都要豪华的嘉宾阵容。Holger Riegel 和 Tobias Kreß 详细地为我们描述了他们将应用升级到 iOS 7 的全过程。当我们为 iOS 7 重新设计应用的时候，一个非常值得考虑的事情就是添加力学特性－UIDynamics，Ash Furrow 为我们展示了如何在 Collection View 中使用这一新的特性。Chris 撰文讨论新的 View Controller 切换动画的 API，Mattt Thompson 写了一篇如何从使用 NSURLConnection 过渡到使用新的 NSURLSession 来进行网络方面的请求，而 David 为我们展现了 iOS 7中多任务的新潜力。Max Seelemann 的文章为我们介绍了 iOS 新系统中最具创新性和革命性的框架：TextKit。最后，Peter Steinberger 将带我们去见识一下 iOS 7 中他非常喜欢的一些新特性。";
//    
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.lineSpacing = 8;
//    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:test];
//    [att addAttributes:@{NSFontAttributeName : lbTest.font, NSParagraphStyleAttributeName: style} range:NSMakeRange(0, test.length)];
//    lbTest.attributedText = att;
//    CGSize size = [att boundingRectWithSize:CGSizeMake(self.view.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//    lbTest.height = size.height;
//    NSLog(@"%@",NSStringFromCGSize(size));
//    
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
//    [self.view addSubview:imageView];
    
//    CALayer *avatarBorder = [CALayer layer];
//    avatarBorder.frame = imageView.bounds;
//    avatarBorder.borderWidth = 0.5;
//    avatarBorder.borderColor = [UIColor colorWithWhite:0.000 alpha:0.090].CGColor;
//    avatarBorder.cornerRadius = imageView.height / 2;
//    avatarBorder.shouldRasterize = YES;
//    avatarBorder.rasterizationScale = [UIScreen mainScreen].scale;
//    [imageView.layer addSublayer:avatarBorder];

//    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//        imageView.image = [image imageByRoundCornerRadius:image.size.width/2.0 corners:UIRectCornerAllCorners borderWidth:8 borderColor:[UIColor redColor] borderLineJoin:kCGLineJoinRound];
//    }];
//    
//    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//        NSLog(@"11111");
//    }];
//    [tap addActionBlock:^(id  _Nonnull sender) {
//        if ([sender isKindOfClass:[UILongPressGestureRecognizer class]]) {
//            NSLog(@"mrwelf");
//        }
//        NSLog(@"22222");
//    }];
//    [self.view addGestureRecognizer:tap];
//    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lbTest.frame)+20, self.view.width, 80)];
//    btn.backgroundColor = [UIColor redColor];
//    [btn setTitle:@"我是一个按钮" forState:UIControlStateNormal];
//    [btn addBlockForControlEvents:UIControlEventTouchDown block:^(id  _Nonnull sender) {
//        NSLog(@"我是一个按钮");
//    }];
//    [self.view addSubview:btn];
//    
////    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
////    view.backgroundColor = [UIColor redColor];
////    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
//    self.navigationItem.backBarButtonItem.actionBlock = ^(id sender){
//        NSLog(@"haha");
//    };
//    self.navigationItem.leftBarButtonItem = item;
   
/*
 UIKIT_EXTERN NSString * const NSFontAttributeName NS_AVAILABLE(10_0, 6_0);                // UIFont, default Helvetica(Neue) 12
 UIKIT_EXTERN NSString * const NSParagraphStyleAttributeName NS_AVAILABLE(10_0, 6_0);      // NSParagraphStyle, default defaultParagraphStyle
 UIKIT_EXTERN NSString * const NSForegroundColorAttributeName NS_AVAILABLE(10_0, 6_0);     // UIColor, default blackColor
 UIKIT_EXTERN NSString * const NSBackgroundColorAttributeName NS_AVAILABLE(10_0, 6_0);     // UIColor, default nil: no background
 UIKIT_EXTERN NSString * const NSLigatureAttributeName NS_AVAILABLE(10_0, 6_0);            // NSNumber containing integer, default 1: default ligatures, 0: no ligatures
 UIKIT_EXTERN NSString * const NSKernAttributeName NS_AVAILABLE(10_0, 6_0);                // NSNumber containing floating point value, in points; amount to modify default kerning. 0 means kerning is disabled.
 UIKIT_EXTERN NSString * const NSStrikethroughStyleAttributeName NS_AVAILABLE(10_0, 6_0);  // NSNumber containing integer, default 0: no strikethrough
 UIKIT_EXTERN NSString * const NSUnderlineStyleAttributeName NS_AVAILABLE(10_0, 6_0);      // NSNumber containing integer, default 0: no underline
 UIKIT_EXTERN NSString * const NSStrokeColorAttributeName NS_AVAILABLE(10_0, 6_0);         // UIColor, default nil: same as foreground color
 UIKIT_EXTERN NSString * const NSStrokeWidthAttributeName NS_AVAILABLE(10_0, 6_0);         // NSNumber containing floating point value, in percent of font point size, default 0: no stroke; positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0)
 UIKIT_EXTERN NSString * const NSShadowAttributeName NS_AVAILABLE(10_0, 6_0);              // NSShadow, default nil: no shadow
 UIKIT_EXTERN NSString *const NSTextEffectAttributeName NS_AVAILABLE(10_10, 7_0);          // NSString, default nil: no text effect
 
 UIKIT_EXTERN NSString * const NSAttachmentAttributeName NS_AVAILABLE(10_0, 7_0);          // NSTextAttachment, default nil
 UIKIT_EXTERN NSString * const NSLinkAttributeName NS_AVAILABLE(10_0, 7_0);                // NSURL (preferred) or NSString
 UIKIT_EXTERN NSString * const NSBaselineOffsetAttributeName NS_AVAILABLE(10_0, 7_0);      // NSNumber containing floating point value, in points; offset from baseline, default 0
 UIKIT_EXTERN NSString * const NSUnderlineColorAttributeName NS_AVAILABLE(10_0, 7_0);      // UIColor, default nil: same as foreground color
 UIKIT_EXTERN NSString * const NSStrikethroughColorAttributeName NS_AVAILABLE(10_0, 7_0);  // UIColor, default nil: same as foreground color
 UIKIT_EXTERN NSString * const NSObliquenessAttributeName NS_AVAILABLE(10_0, 7_0);         // NSNumber containing floating point value; skew to be applied to glyphs, default 0: no skew
 UIKIT_EXTERN NSString * const NSExpansionAttributeName NS_AVAILABLE(10_0, 7_0);           // NSNumber containing floating point value; log of expansion factor to be applied to glyphs, default 0: no expansion
 
 UIKIT_EXTERN NSString * const NSWritingDirectionAttributeName NS_AVAILABLE(10_6, 7_0);    // NSArray of NSNumbers representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.  The control characters can be obtained by masking NSWritingDirection and NSWritingDirectionFormatType values.  LRE: NSWritingDirectionLeftToRight|NSWritingDirectionEmbedding, RLE: NSWritingDirectionRightToLeft|NSWritingDirectionEmbedding, LRO: NSWritingDirectionLeftToRight|NSWritingDirectionOverride, RLO: NSWritingDirectionRightToLeft|NSWritingDirectionOverride,
 
 UIKIT_EXTERN NSString * const NSVerticalGlyphFormAttributeName NS_AVAILABLE(10_7, 6_0);   // An NSNumber containing an integer value.  0 means horizontal text.  1 indicates vertical text.  If not specified, it could follow higher-level vertical orientation settings.  Currently on iOS, it's always horizontal.  The behavior for any other value is undefined.
 */

//- (void)show:(NSNotification *)noti
//{
//    NSLog(@"%@",noti.userInfo);
//}
//- (void)action:(UIButton *)btn
//{
//    MSUserGuidanceViewController *vc = [[MSUserGuidanceViewController alloc] init];
//    vc.isUserGuidance = NO;
//    vc.modalPresentationStyle = UIModalPresentationCustom;
//    vc.transitioningDelegate = self;
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
//}
//
//- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    self.transition = [[MSBubbleTransition alloc] init];
//    self.transition.transitionMode = MSBubbleTransitionMode_present;
//    self.transition.startingPoint = self.btnAdd.center;
//    self.transition.bubbleColor = self.btnAdd.backgroundColor;
//    return self.transition;
//}
//
//- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    self.transition.transitionMode = MSBubbleTransitionMode_dismiss;
//    self.transition.startingPoint = self.btnAdd.center;
//    self.transition.bubbleColor = self.btnAdd.backgroundColor;
//    return self.transition;
//}
//
//#pragma mark 查看所有内置滤镜
//-(void)showAllFilters{
//    NSArray *filterNames=[CIFilter filterNamesInCategory:kCICategoryBuiltIn];
//    for (NSString *filterName in filterNames) {
//        CIFilter *filter=[CIFilter filterWithName:filterName];
//        NSLog(@"\rfilter:%@\rattributes:%@",filterName,[filter attributes]);
//    }
//}
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.pinView resignFirstResponder];
//    [self.view endEditing:YES];
//    MSAlertController *alertVc = [MSAlertController alertControllerWithTitle:nil message:@"因交易密码错误多次，账号已锁定，请找回交易密码解锁" preferredStyle:UIAlertControllerStyleAlert];
//    alertVc.msmessageColor = [UIColor ms_colorWithHexString:@"#555555"];
//    MSAlertAction *cancel = [MSAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
//    cancel.mstextColor = [UIColor ms_colorWithHexString:@"#666666"];
//    MSAlertAction *sure = [MSAlertAction actionWithTitle:@"立即找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    sure.mstextColor = [UIColor ms_colorWithHexString:@"#333092"];
//    [alertVc addAction:cancel];
//    [alertVc addAction:sure];
//    [self presentViewController:alertVc animated:YES completion:nil];
//    
//    
//    {
//        unsigned int count = 0;
//        Ivar *ivars = class_copyIvarList([UITableView class], &count);
//        for(int i =0;i < count;i ++){
//            Ivar ivar = ivars[i];
//            NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
//            NSString *ivarType = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
//            NSLog(@"%@=====%@",ivarName,ivarType);
//        }
//    }
//    NSLog(@"============================华丽的分割线==============================");
//    {
//        unsigned int count = 0;
//        Ivar *ivars = class_copyIvarList([UIGestureRecognizer class], &count);
//        for(int i =0;i < count;i ++){
//            Ivar ivar = ivars[i];
//            NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
//            NSString *ivarType = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
//            NSLog(@"%@=====%@",ivarName,ivarType);
//        }
//    }
//    
//}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    /*
//     @property (nullable, readonly, copy) NSString *host;
//     @property (nullable, readonly, copy) NSNumber *port;
//     @property (nullable, readonly, copy) NSString *user;
//     @property (nullable, readonly, copy) NSString *password;
//     @property (nullable, readonly, copy) NSString *path;
//     @property (nullable, readonly, copy) NSString *fragment;
//     @property (nullable, readonly, copy) NSString *parameterString;
//     @property (nullable, readonly, copy) NSString *query;
//     @property (nullable, readonly, copy) NSString *relativePath;
//     */
////    NSLog(@"%@",NSHomeDirectory());
//    
//    
//    
//    NSURL *url = [NSURL URLWithString:@"https://test.mjsfax.net:6109/start-recharge?sessionId=fc25a9e4-5d1b-4a52-b749-97df8be28e8b&transAmt=22.000000"];
//    NSLog(@"scheme==%@",url.scheme);
//    NSLog(@"host==%@",url.host);
//    NSLog(@"port==%@",url.port);
//    NSLog(@"user==%@",url.user);
//    NSLog(@"password==%@",url.password);
//    NSLog(@"path==%@",url.path);
//    NSLog(@"fragment==%@",url.fragment);
//    NSLog(@"parameterString==%@",url.parameterString);
//    NSLog(@"query==%@",url.query);
//    NSLog(@"relativePath==%@",url.relativePath);
//    
//    
//    
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self.view];
//    if (point.y < [UIScreen mainScreen].bounds.size.height/2.0) {
//        
//        MSAlertView *alertView = [MSAlertView ms_alertControllerWithTitle:@"测试测试测试" message:@"1.几乎都被环境建设的被环境建设的；\r\n2.几乎都境建设的被环境建的被环境建设的；\r\n3.几乎都被环境建设的被环境建设的；\r\n4.境被环境建设建设的建设的被环境建设的。"];
//        MSAlertAction *sureActon = [MSAlertAction ms_actionWithTitle:@"确定" handler:^(MSAlertAction *alertAction) {
//            NSLog(@"sureActon");
//        }];
//        MSAlertAction *cancelActon = [MSAlertAction ms_actionWithTitle:@"取消" handler:^(MSAlertAction *alertAction) {
//            NSLog(@"cancelActon");
//        }];
//        
//        alertView.actions = @[sureActon, cancelActon];
//        [alertView show];
//        
//    }else{
//        
//        if (point.x < self.view.width / 2.0) {
//            
//            MSCardViewController *vc = [[MSCardViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        }else{
//            
//            [MSAssetUtil requestAuthorizationSuccess:^{
//                
//                
//                __weak typeof(self) weakSelf = self;
//                MSPhotoSelectorController *vc = [[MSPhotoSelectorController alloc] init];
//                vc.callBlack = ^(UIImage *image){
//                    weakSelf.imageView.image = image;
//                };
//                MSNavigationController *nav = [[MSNavigationController alloc] initWithRootViewController:vc];
//                
//                [self.navigationController presentViewController:nav animated:YES completion:^{
//                    
//                }];
//                
//                
//            } faliure:^{
//                
//                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"在iPhone的\"设置-隐私-相册\"中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                }];
//                [alert addAction:action];
//                
//                [self presentViewController:alert animated:YES completion:nil];
//            }];
//
//            
//            
//        }
//        
//    }
//    
////    NSArray *arr = [[MSRegionManager shareManager] provinces];
////    for (int i = 0; i < arr.count; i++) {
////        MSRegion *region = arr[i];
////            for (MSRegion *city in [region.children allValues]) {
////                
//////                 NSLog(@"%@===%@===%@",region.name,city.name,[[MSRegionManager shareManager] areasForProvinceCode:region.code cityCode:city.code]);
////                
////                for (MSRegion *area  in [city.children allValues]) {
////                    NSLog(@"%@===%@===%@",region.name,city.name,[[[MSRegionManager shareManager] areaWithProvinceCode:region.code cityCode:city.code areaCode:area.code] name]);
////                }
////                
////                
////            }
////        
////    }
//    
//    
////    //属性动画
////    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)];
////    label.textAlignment = NSTextAlignmentCenter;
////    [self.view addSubview:label];
////    
////    POPBasicAnimation * labelBani = [POPBasicAnimation animation];
////    labelBani.duration = 1;
////    [labelBani setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            [label removeFromSuperview];
////        });
////    }];
////    
////    POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
////        [prop setReadBlock:^(id obj, CGFloat values[]) {
////            
////            values[0] = [[obj description] floatValue];
////    
////        }];
////        [prop setWriteBlock:^(id obj, const CGFloat values[]) {
//////            NSLog(@"=====%lf",values[0]);
////            NSString * str =[NSString stringWithFormat:@"%.2f",values[0]];
////            [obj setText:[NSString stringWithFormat:@"%@%%",str]];
////        }];
//////        prop.threshold = 0.4;
////    }];
////    
////    labelBani.property = prop;
////    labelBani.fromValue = @(0.0);
////    labelBani.toValue = @(7877.43);
////    [label pop_addAnimation:labelBani forKey:@"123"];
//    
//}
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    NSLog(@"gestureRecognizerShouldBegin");
//    return YES;
//}
//- (void)adjustFrameWithImage:(UIImage *)image
//{
//    CGFloat imageViewHeight = self.view.frame.size.width * (image.size.height / image.size.width);
//    if (imageViewHeight > self.view.frame.size.height) {
//        self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, imageViewHeight);
//    }else{
//        self.imageView.frame = CGRectMake(0, (self.view.frame.size.height - imageViewHeight) / 2.0, self.view.frame.size.width, imageViewHeight);
//    }
//}

