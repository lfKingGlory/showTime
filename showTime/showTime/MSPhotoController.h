//
//  MSPhotoBrowserController.h
//  showTime
//
//  Created by msj on 16/9/26.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MSPhotoControllerType) {
    MSPhotoController_push,
    MSPhotoController_present
};

@class MSPhotoItem;

@interface MSPhotoController : UIViewController
@property (strong, nonatomic) NSArray <MSPhotoItem *>*photoItems;
@property (assign, nonatomic) int currentIndex;
@property (assign, nonatomic) MSPhotoControllerType type;

@end
