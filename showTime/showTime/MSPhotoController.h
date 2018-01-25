//
//  MSPhotoBrowserController.h
//  showTime
//
//  Created by msj on 16/9/26.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSPhotoItem;

@interface MSPhotoController : UIView
@property (strong, nonatomic) NSArray <MSPhotoItem *>*photoItems;
@property (assign, nonatomic) int currentIndex;
@end
