//
//  BBMCollectionViewWaterLayout.m
//  瀑布流
//
//  Created by liufei on 16/6/10.
//  Copyright © 2016年 liufei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBMCollectionViewWaterLayout;

@protocol BBMCollectionViewWaterLayoutDelegate <NSObject>

@required
- (CGFloat)collectionViewWaterLayout:(BBMCollectionViewWaterLayout *)collectionViewWaterLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath withItemWidth:(CGFloat)itemWidth;

@optional
- (NSInteger)columnNumbersInBBMCollectionViewWaterLayout:(BBMCollectionViewWaterLayout *)collectionViewWaterLayout;
- (CGFloat)columMarginInBBMCollectionViewWaterLayout:(BBMCollectionViewWaterLayout *)collectionViewWaterLayout;
- (CGFloat)rowMarginInBBMCollectionViewWaterLayout:(BBMCollectionViewWaterLayout *)collectionViewWaterLayout;
- (UIEdgeInsets)edgeInsertsInBBMCollectionViewWaterLayout:(BBMCollectionViewWaterLayout *)collectionViewWaterLayout;

@end

@interface BBMCollectionViewWaterLayout : UICollectionViewLayout
@property (nonatomic,weak) id <BBMCollectionViewWaterLayoutDelegate>delegate;
@end
