//
//  BBMPageControl.m
//  刘飞
//
//  Created by BBM on 15/12/24.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSPageControl : UIView

@property(nonatomic, assign) NSInteger numberOfPages;

@property(nonatomic, assign) NSInteger currentPage;

@property(nonatomic, assign) BOOL hidesForSinglePage;          

@property(nonatomic, strong) UIImage *currentPageImage;

@property(nonatomic, strong) UIImage *pageImage;

@property(nonatomic, assign) NSInteger imageDistance;

@property(nonatomic, assign) CGFloat imageWidth;

@property(nonatomic, assign) CGFloat imageHeight;

@end
