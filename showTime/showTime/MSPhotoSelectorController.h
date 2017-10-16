//
//  MSPhotoSelectorController.h
//  showTime
//
//  Created by msj on 16/10/12.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAssetUtil.h"

@interface MSPhotoSelectorController : UIViewController
@property (copy, nonatomic) void (^callBlack)(UIImage *image);
@end

/*  记得在info.plist文件里配置好下面的参数
    Localizations     array                3items
 
    item0             String               English
    item1             String               Chinese (simplified)
    item2             String               Chinese (traditional)
 */
