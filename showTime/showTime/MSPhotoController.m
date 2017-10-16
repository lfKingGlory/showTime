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

#define padding  20

@interface MSPhotoController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UIButton *btnSave;
@end

@implementation MSPhotoController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self addSubviews];
    
}

- (void)addSubviews
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-padding/2.0, 0, self.view.frame.size.width + padding, self.view.frame.size.height)];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.photoItems.count * self.scrollView.frame.size.width, 0);
    [self.scrollView setContentOffset:CGPointMake(self.currentIndex * self.scrollView.frame.size.width, 0) animated:NO];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < self.photoItems.count; i++) {
        MSPhotoItem *photoItem = self.photoItems[i];
        MSPhotoView *photoView = [[MSPhotoView alloc] initWithFrame:CGRectMake(i * (self.view.frame.size.width + padding) + padding/2.0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        photoView.photoItem = photoItem;
        [self.scrollView addSubview:photoView];
        photoView.singleTapBlock = ^(UIGestureRecognizer *recognizer){
            if (self.type == MSPhotoController_present) {
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
    }
    
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 40, 200, 20)];
    self.lbTitle.textColor = [UIColor whiteColor];
    self.lbTitle.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.lbTitle];
    self.lbTitle.text = [NSString stringWithFormat:@"%d/%lu",self.currentIndex+1,(unsigned long)self.photoItems.count];
    
    self.btnSave = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, self.view.frame.size.height - 40, 40, 20)];
    [self.btnSave setTitle:@"保存" forState:UIControlStateNormal];
    [self.btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSave addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSave];
    
    [self downLoadImageOfPhotoViewForIndex:self.currentIndex];
   
}

- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    
    MSPhotoView *currentView = _scrollView.subviews[index];
    
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
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
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
    MSPhotoView *photoView = self.scrollView.subviews[index];
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
