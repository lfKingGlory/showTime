//
//  MSPhotoViewController.m
//  showTime
//
//  Created by msj on 16/10/13.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSPhotoViewController.h"

@interface MSPhotoViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;

@property (assign, nonatomic) BOOL isShowBottomView;
@end

@implementation MSPhotoViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isShowBottomView = YES;
    [self addScrollView];
    [self addBottomView];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    [MSAssetUtil getImageByAsset:self.phAsset makeSize:CGSizeMake(self.phAsset.pixelWidth * scale, self.phAsset.pixelHeight * scale) makeResizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage *assetImage) {
        self.imageView.image = assetImage;
        [self adjustFrameWithImage:assetImage];
    }];
    
    [self.view addGestureRecognizer:self.doubleTap];
    [self.view addGestureRecognizer:self.singleTap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)addScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 2;
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] init];
    [self.scrollView addSubview:self.imageView];
}

- (void)addBottomView
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 60)];
    self.bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:self.bottomView];
    
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, self.bottomView.frame.size.height)];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.showsTouchWhenHighlighted = YES;
    [self.bottomView addSubview:btnCancel];
    
    UIButton *btnSure = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width - 60, 0, 60, self.bottomView.frame.size.height)];
    [btnSure setTitle:@"确定" forState:UIControlStateNormal];
    [btnSure addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    btnSure.showsTouchWhenHighlighted = YES;
    [self.bottomView addSubview:btnSure];
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure
{
    if (self.block) {
        self.block(self.imageView.image);
    }
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired = 1;
    }
    return _doubleTap;
}

- (UITapGestureRecognizer *)singleTap
{
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
    }
    return _singleTap;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self.view];
    if (self.scrollView.zoomScale <= 1.0) {
        CGFloat scaleX = touchPoint.x + self.scrollView.contentOffset.x;
        CGFloat sacleY = touchPoint.y + self.scrollView.contentOffset.y;
        [self.scrollView zoomToRect:CGRectMake(scaleX, sacleY, 1, 1) animated:YES];
    } else {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.isShowBottomView) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.transform = CGAffineTransformMakeTranslation(0, 60);
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.transform = CGAffineTransformTranslate(self.bottomView.transform, 0, -60);
        }];
    }
    self.isShowBottomView = !self.isShowBottomView;
}

- (void)adjustFrameWithImage:(UIImage *)image
{
    CGFloat imageViewHeight = self.view.frame.size.width * (image.size.height / image.size.width);
    if (imageViewHeight > self.view.frame.size.height) {
        self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, imageViewHeight);
    }else{
        self.imageView.frame = CGRectMake(0, (self.view.frame.size.height - imageViewHeight) / 2.0, self.view.frame.size.width, imageViewHeight);
    }
    self.scrollView.contentSize = self.imageView.frame.size;
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.imageView.center = [self centerOfScrollViewContent:scrollView];
    
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}
@end
