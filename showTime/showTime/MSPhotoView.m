//
//  MSPhotoItem.m
//  showTime
//
//  Created by msj on 16/9/26.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSPhotoView.h"
#import "MSLoadingView.h"
#import "UIImageView+WebCache.h"

@interface MSPhotoView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) MSLoadingView *loadingView;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) UIImage *placeHolderImage;

@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;
@property (assign, nonatomic) BOOL hasLoadedImage;

@end

@implementation MSPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.hasLoadedImage = NO;
        self.beginLoadingImage = NO;
        [self addSubviews];
        [self addGestureRecognizer:self.doubleTap];
        [self addGestureRecognizer:self.singleTap];
    }
    return self;
}

- (void)addSubviews
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 2;
    [self addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 100) * 0.5, (self.frame.size.height - 100) * 0.5, 100, 100)];
    self.imageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.imageView];
    
    self.loadingView = [[MSLoadingView alloc] initWithFrame:CGRectMake((self.frame.size.width - 50) * 0.5, (self.frame.size.height - 50) * 0.5, 50, 50)];
    self.loadingView.loadingViewType = MSLoadingViewType_text;
    self.loadingView.hidden = YES;
    [self addSubview:self.loadingView];
    
    self.reloadButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 200) * 0.5, (self.frame.size.height - 40) * 0.5, 200, 40)];
    self.reloadButton.layer.cornerRadius = 2;
    self.reloadButton.clipsToBounds = YES;
    self.reloadButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.reloadButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
    [self.reloadButton setTitle:@"原图加载失败，点击重新加载" forState:UIControlStateNormal];
    [self.reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.reloadButton addTarget:self action:@selector(reloadImage) forControlEvents:UIControlEventTouchUpInside];
    self.reloadButton.hidden = YES;
    [self addSubview:self.reloadButton];
}

- (void)reloadImage
{
    [self setImageWithURL:self.imageUrl placeholderImage:self.placeHolderImage];
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

- (void)reset
{
    [self.scrollView setZoomScale:1.0 animated:YES];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    self.reloadButton.hidden = YES;
    self.loadingView.hidden = NO;
    _imageUrl = url;
    _placeHolderImage = placeholder;
    
    __weak __typeof(self)weakSelf = self;
    [self.imageView sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed | SDWebImageAllowInvalidSSLCertificates progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        CGFloat progress = (CGFloat)receivedSize / expectedSize;
        if (progress <= 0) {
            strongSelf.loadingView.progress = 0.01;
        }else{
            strongSelf.loadingView.progress = progress;
        }
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.loadingView.hidden = YES;
        
        if (error) {
            strongSelf.reloadButton.hidden = NO;
            strongSelf.hasLoadedImage = NO;
        }else{
            strongSelf.hasLoadedImage = YES;
            strongSelf.reloadButton.hidden = YES;
            [self adjustFrameWithImage:image];
        }
    }];
    
}

- (void)adjustFrameWithImage:(UIImage *)image
{
    CGFloat imageViewHeight = self.frame.size.width * (image.size.height / image.size.width);
    if (imageViewHeight > self.frame.size.height) {
        self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, imageViewHeight);
    }else{
        self.imageView.frame = CGRectMake(0, (self.frame.size.height - imageViewHeight) / 2.0, self.frame.size.width, imageViewHeight);
    }
    self.scrollView.contentSize = self.imageView.frame.size;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    if (!self.hasLoadedImage) {
        return;
    }
    CGPoint touchPoint = [recognizer locationInView:self];
    if (self.scrollView.zoomScale <= 1.0) {
        CGFloat scaleX = touchPoint.x + self.scrollView.contentOffset.x;
        CGFloat sacleY = touchPoint.y + self.scrollView.contentOffset.y;
        [self.scrollView zoomToRect:CGRectMake(scaleX, sacleY, 1, 1) animated:YES];
    } else {
        [self reset];
    }
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.singleTapBlock) {
        self.singleTapBlock(recognizer);
    }
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
