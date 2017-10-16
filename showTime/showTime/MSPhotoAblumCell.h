//
//  MSPhotoAblumCell.h
//  showTime
//
//  Created by msj on 16/10/12.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAssetUtil.h"

@interface MSPhotoAblumCell : UITableViewCell
+ (MSPhotoAblumCell *)cellWithTableView:(UITableView *)tableView;
@property (strong, nonatomic) MSAssetModel *assetModel;

@end
