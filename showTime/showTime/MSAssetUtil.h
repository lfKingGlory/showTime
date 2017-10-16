//
//  MSAlbumAssetUtil.h
//  showTime
//
//  Created by msj on 16/10/12.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

#pragma mark - MSAssetModel
@interface MSAssetModel : NSObject
/**
 *  相册的名字
 */
@property(nonatomic,strong)NSString * title;
/**
 *  该相册的照片数量
 */
@property(nonatomic,assign)NSInteger  photoNumber;
/**
 *  该相册的第一张图片
 */
@property(nonatomic,strong)PHAsset * firstAsset;
/**
 *  通过该属性可以取得该相册的所有照片
 */
@property(nonatomic,strong)PHAssetCollection * assetCollection;
@end


#pragma mark - MSAssetUtil
@interface MSAssetUtil : NSObject
/**
 *  判断相册是否可用
 */
+ (BOOL)isAlbumAuthority;
/**
 *  获取相册权限
 */
+ (void)requestAuthorizationSuccess:(void (^) (void))success  faliure:(void (^) (void))faliure;
/**
 *  判断相机是否可用
 */
+ (BOOL)isCameraAuthority;
/**
 *  获得所有的相册
 *
 *  @return  MSAssetModel样式的相册
 */

+ (NSMutableArray<MSAssetModel *> *)getAllAssetModel;

/**
 *  取到对应的照片实体
 *
 *  @param asset      索取照片实体的媒介
 *  @param size       实际想要的照片大小
 *  @param resizeMode 控制照片尺寸
 *  @param completion block返回照片实体
 */
+ (void)getImageByAsset:(PHAsset *)asset makeSize:(CGSize)size makeResizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage * AssetImage))completion;

/**
 *   取得所有的照片资源
 *
 *  @param ascending 排序方式
 *
 *  @return 照片资源
 */

+ (NSMutableArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending;

/**
 *  获取指定相册内的所有图片
 */
+ (NSMutableArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;
@end
