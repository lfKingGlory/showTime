//
//  MSPhotoViewController.h
//  showTime
//
//  Created by msj on 16/10/13.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAssetUtil.h"

@interface MSPhotoViewController : UIViewController
@property (strong, nonatomic) PHAsset *phAsset;
@property (copy, nonatomic) void (^block)(UIImage *image);
@end
