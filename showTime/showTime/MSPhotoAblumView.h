//
//  MSPhotoAblumView.h
//  showTime
//
//  Created by msj on 16/10/12.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAssetUtil.h"

@class MSPhotoAblumView;
@protocol MSPhotoAblumViewDelegate <NSObject>
@optional
- (void)ms_photoAblumView:(MSPhotoAblumView *)photoAblumView didSelectAssetModel:(MSAssetModel *)assetModel;
@end

@interface MSPhotoAblumView : UIView
@property (strong, nonatomic) NSMutableArray <MSAssetModel *>*photoAblumArrM;
@property (weak, nonatomic) id <MSPhotoAblumViewDelegate>delegate;
@end
