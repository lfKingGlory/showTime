//
//  MSPhotoItem.h
//  showTime
//
//  Created by msj on 16/9/26.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPhotoItem.h"

@interface MSPhotoView : UIView
@property (nonatomic, strong) void (^singleTapBlock)(UITapGestureRecognizer *recognizer);
@property (nonatomic, assign) BOOL beginLoadingImage;
@property (strong, nonatomic) MSPhotoItem *photoItem;
@property (strong, nonatomic) UIImageView *imageView;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)reset;
@end
