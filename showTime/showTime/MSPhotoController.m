//
//  MSPhotoBrowserController.m
//  showTime
//
//  Created by msj on 16/9/26.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSPhotoController.h"
#import "MSPhotoView.h"
#import "MSPhotoItem.h"
#import "UIView+FrameUtil.h"

#define padding  20

typedef NS_ENUM(NSInteger, PanGestureDirection) {
    PanGestureDirectionLeft,
    PanGestureDirectionRight,
    PanGestureDirectionTop,
    PanGestureDirectionBottom
};

@interface MSPhotoController ()<UIScrollViewDelegate>
@property (strong, nonatomic) NSArray <MSPhotoItem *>*photoItems;
@property (assign, nonatomic) int currentIndex;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UIButton *btnSave;

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (assign, nonatomic) PanGestureDirection direction;
@property (assign, nonatomic) BOOL isAction;

@property (strong, nonatomic) UIImageView *currentImageView;
@property (strong, nonatomic) UIView *currentImageViewSuperView;
@property (assign, nonatomic) CGRect origialFrame;
@property (assign, nonatomic) CGRect newFrame;
@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) CGFloat scale;
@end

@implementation MSPhotoController
#pragma mark - life
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isAction = NO;
        self.backgroundColor = [UIColor clearColor];
        [self addSubviews];
        [self addGestureRecognizer:self.panGesture];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        return;
    }
    if (![newSuperview isKindOfClass:[UIView class]]) {
        return;
    }
    [super willMoveToSuperview:newSuperview];
    [self downLoadImageOfPhotoViewForIndex:self.currentIndex];
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeFromSuperview {
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.alpha = 0;
        self.currentImageView.y = self.height;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

#pragma mark - public
- (void)updateWithPhotoItems:(NSArray<MSPhotoItem *> *)photoItems currentIndex:(int)currentIndex {
    _photoItems = photoItems;
    _currentIndex = currentIndex;
    
    for (int i = 0; i < self.photoItems.count; i++) {
        MSPhotoItem *photoItem = self.photoItems[i];
        MSPhotoView *photoView = [[MSPhotoView alloc] initWithFrame:CGRectMake(i * (self.frame.size.width + padding) + padding/2.0, 0, self.frame.size.width, self.frame.size.height)];
        photoView.photoItem = photoItem;
        [self.scrollView addSubview:photoView];
        photoView.singleTapBlock = ^(UIGestureRecognizer *recognizer){
            [self removeFromSuperview];
        };
    }
    self.scrollView.contentSize = CGSizeMake(self.photoItems.count * self.scrollView.frame.size.width, 0);
    [self.scrollView setContentOffset:CGPointMake(self.currentIndex * self.scrollView.frame.size.width, 0) animated:NO];
    self.lbTitle.text = [NSString stringWithFormat:@"%d/%lu",self.currentIndex+1,(unsigned long)self.photoItems.count];
}

#pragma mark - private
- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    }
    return _panGesture;
    
}

- (void)pan:(UIPanGestureRecognizer *)panGes {
    CGPoint translationP = [panGes translationInView:self];
    CGPoint velocityP = [panGes velocityInView:self];
    CGPoint locationP = [panGes locationInView:self];
    switch (panGes.state) {
        case UIGestureRecognizerStateBegan:
        {
            
            if (translationP.y >= 0 && velocityP.y > 0) {
                if (ABS(translationP.x) <= ABS(translationP.y)) {
                    self.direction = PanGestureDirectionBottom;
                } else if (translationP.x <= 0 && velocityP.x < 0) {
                    self.direction = PanGestureDirectionLeft;
                } else {
                    self.direction = PanGestureDirectionRight;
                }
            } else {
                if (ABS(translationP.x) <= ABS(translationP.y)) {
                    self.direction = PanGestureDirectionTop;
                } else if (translationP.x <= 0 && velocityP.x < 0) {
                    self.direction = PanGestureDirectionLeft;
                } else {
                    self.direction = PanGestureDirectionRight;
                }
            }
            
            switch (self.direction) {
                case PanGestureDirectionLeft:
                {
                    NSLog(@"向左");
                    break;
                }
                case PanGestureDirectionRight:
                {
                    NSLog(@"向右");
                    break;
                }
                case PanGestureDirectionTop:
                {
                    NSLog(@"向上");
                    break;
                }
                case PanGestureDirectionBottom:
                {
                    NSLog(@"向下");
                    break;
                }
                default:
                    break;
            }
            
            int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
            MSPhotoView *currentView = _scrollView.subviews[index];
            if (!currentView.hasLoadedImage) {
                self.isAction = NO;
                return;
            }
            
            self.isAction = (translationP.y >= 0 && velocityP.y > 0);
            if (self.isAction) {
                self.currentImageView = currentView.imageView;
                self.currentImageViewSuperView = currentView.imageView.superview;
                self.origialFrame = currentView.imageView.frame;
                self.newFrame = [currentView convertRect:currentView.imageView.frame toView:self];
                
                [self addSubview:self.currentImageView];
                self.currentImageView.frame = self.newFrame;
                
                self.scrollView.userInteractionEnabled = NO;
                self.startPoint = locationP;
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (self.isAction) {
                self.scale = 1;
                if (locationP.y - self.startPoint.y > 0) {
                    self.scale = ABS(locationP.y - self.startPoint.y) / self.frame.size.height;
                    self.scale = MAX(1 - self.scale, 0.2);
                } else {
                    self.scale = 1;
                }
                self.scrollView.alpha = self.scale;
                self.currentImageView.width = self.newFrame.size.width * self.scale;
                self.currentImageView.height = self.newFrame.size.height * self.scale;
                
                CGFloat centerX = self.newFrame.origin.x+self.newFrame.size.width/2.0 + (locationP.x - self.startPoint.x)*0.8;
                CGFloat centerY = self.newFrame.origin.y+self.newFrame.size.height/2.0 + (locationP.y - self.startPoint.y)*0.8;
                self.currentImageView.center = CGPointMake(centerX, centerY);
                
                self.btnSave.hidden = YES;
                self.lbTitle.hidden = YES;
                
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        default:
        {
            if (self.isAction) {
                self.isAction = NO;
                if (self.scale >= 0.6) {
                    [UIView animateWithDuration:0.25 animations:^{
                        self.currentImageView.frame = self.newFrame;
                        self.scrollView.alpha = 1;
                        self.btnSave.hidden = NO;
                        self.lbTitle.hidden = NO;
                    } completion:^(BOOL finished) {
                        self.currentImageView.frame = self.origialFrame;
                        [self.currentImageViewSuperView addSubview:self.currentImageView];
                        self.scrollView.userInteractionEnabled = YES;
                    }];
                } else {
                    [self removeFromSuperview];
                    self.scrollView.userInteractionEnabled = YES;
                }
            }
            break;
        }
    }
}

- (void)addSubviews
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-padding/2.0, 0, self.frame.size.width + padding, self.frame.size.height)];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.alpha = 0;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height - 40, 200, 20)];
    self.lbTitle.textColor = [UIColor whiteColor];
    self.lbTitle.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.lbTitle];
    
    self.btnSave = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, self.frame.size.height - 40, 40, 20)];
    [self.btnSave setTitle:@"保存" forState:UIControlStateNormal];
    [self.btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSave addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnSave];
}

- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    MSPhotoView *currentView = _scrollView.subviews[index];
    if (!currentView.hasLoadedImage) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
        label.layer.cornerRadius = 5;
        label.clipsToBounds = YES;
        label.bounds = CGRectMake(0, 0, 150, 40);
        label.center = self.center;
        label.text = @"正在加载图片...";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:17];
        [[[UIApplication sharedApplication].delegate window] addSubview:label];
        [[[UIApplication sharedApplication].delegate window] bringSubviewToFront:label];
        [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
        return;
    }
    UIImageWriteToSavedPhotosAlbum(currentView.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 40);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[[UIApplication sharedApplication].delegate window] addSubview:label];
    [[[UIApplication sharedApplication].delegate window] bringSubviewToFront:label];
    if (error) {
        label.text = @"保存失败";
    } else {
        label.text = @"保存成功";
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)downLoadImageOfPhotoViewForIndex:(NSInteger)index
{
    MSPhotoView *photoView = (MSPhotoView *)self.scrollView.subviews[index];
    if (photoView.beginLoadingImage) return;
    photoView.beginLoadingImage = YES;
    [photoView setImageWithURL:[NSURL URLWithString:photoView.photoItem.thumbnail_pic] placeholderImage:nil];
}

#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / _scrollView.bounds.size.width + 0.5;
    long left = index - 1;
    long right = index + 1;
    left = left > 0 ? left : 0;
    right = right > self.photoItems.count ? self.photoItems.count : right;
    self.lbTitle.text = [NSString stringWithFormat:@"%d/%lu",index+1,(unsigned long)self.photoItems.count];
    for (long i = left; i < right; i++) {
        [self downLoadImageOfPhotoViewForIndex:i];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (MSPhotoView *photoView in self.scrollView.subviews) {
        [photoView reset];
    }
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
