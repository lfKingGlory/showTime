//
//  BBMPageControl.m
//  刘飞
//
//  Created by BBM on 15/12/24.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import "MSPageControl.h"

@interface MSPageControl ()
@end

@implementation MSPageControl
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.hidesForSinglePage = NO;
        self.numberOfPages = 0;
        self.currentPage = 0;
        self.imageDistance = 5;
        self.imageWidth = 10;
        self.imageHeight = 3;
    }
    return self;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    
    if (numberOfPages > 1) {
        self.hidden = NO;
    }else{
        if (self.hidesForSinglePage) {
            self.hidden = YES;
        }else{
            self.hidden = NO;
        }
    }
    
    [self addImages];
}

- (void)addImages
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat imageViewW = self.imageWidth;
    CGFloat imageViewH = self.imageHeight;
    CGFloat imageViewY = (self.frame.size.height - imageViewH) / 2.0;
    CGFloat leftDistance = (self.frame.size.width - self.numberOfPages * imageViewW - (self.numberOfPages - 1) * self.imageDistance) / 2.0;
    
    for (int i = 0; i < self.numberOfPages; i++) {
        
        CGFloat imageViewX = leftDistance + i * (self.imageDistance + imageViewW);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
        
        imageView.image = self.pageImage;
        
        [self addSubview:imageView];
        
    }
    
    self.currentPage = self.currentPage;
    
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    
    for (int i = 0; i < self.numberOfPages; i++) {
        
        UIImageView *imageView = (UIImageView *)self.subviews[i];
        if (i == currentPage) {
            imageView.image = self.currentPageImage;
        }else{
            imageView.image = self.pageImage;
        }
        
    }
    
    if ((currentPage + 1) > self.numberOfPages) {
        
        UIImageView *imageView = (UIImageView *)self.subviews.lastObject;
        imageView.image = self.currentPageImage;
        
        if (self.numberOfPages >= 1) {
             _currentPage = self.numberOfPages - 1;
        }
        
    }
}
@end
