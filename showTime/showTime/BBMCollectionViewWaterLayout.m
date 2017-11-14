//
//  BBMCollectionViewWaterLayout.m
//  瀑布流
//
//  Created by liufei on 16/6/10.
//  Copyright © 2016年 liufei. All rights reserved.
//

#import "BBMCollectionViewWaterLayout.h"

#define WaterLayoutColumnNumbers 2;
#define WaterLayoutRowMargin  5;
#define WaterLayoutColumnMargin 5;
#define WaterLayoutEdgeInserts  UIEdgeInsetsMake(5, 0, 5, 0);

@interface BBMCollectionViewWaterLayout()
@property(nonatomic , strong)NSMutableArray *attrsArray;
@property(nonatomic , strong)NSMutableArray *maxHeightArray;

- (NSInteger)columnNumbers;
- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (UIEdgeInsets)edgeInserts;

@end


@implementation BBMCollectionViewWaterLayout

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableArray *)maxHeightArray
{
    if (!_maxHeightArray) {
        _maxHeightArray = [NSMutableArray array];
    }
    return _maxHeightArray;
}

- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInBBMCollectionViewWaterLayout:)]) {
        CGFloat rowMargin = [self.delegate rowMarginInBBMCollectionViewWaterLayout:self];
        if (rowMargin > 0) {
            return rowMargin;
        } else {
            return WaterLayoutRowMargin;
        }
    }else{
        return WaterLayoutRowMargin;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columMarginInBBMCollectionViewWaterLayout:)]) {
        CGFloat columnMargin = [self.delegate columMarginInBBMCollectionViewWaterLayout:self];
        if (columnMargin > 0) {
            return columnMargin;
        } else {
            return WaterLayoutColumnMargin;
        }
    }else{
        return WaterLayoutColumnMargin;
    }
}

- (NSInteger)columnNumbers
{
    if ([self.delegate respondsToSelector:@selector(columnNumbersInBBMCollectionViewWaterLayout:)]) {
        NSInteger columnNumbers =  [self.delegate columnNumbersInBBMCollectionViewWaterLayout:self];
        if (columnNumbers > 0) {
            return columnNumbers;
        } else {
            return WaterLayoutColumnNumbers;
        }
    }else{
        return WaterLayoutColumnNumbers;
    }
}

- (UIEdgeInsets)edgeInserts
{
    if ([self.delegate respondsToSelector:@selector(edgeInsertsInBBMCollectionViewWaterLayout:)]) {
        return [self.delegate edgeInsertsInBBMCollectionViewWaterLayout:self];
    }else{
        return WaterLayoutEdgeInserts;
    }
}

- (void)prepareLayout
{
    [super prepareLayout];
    [self.attrsArray removeAllObjects];
    [self.maxHeightArray removeAllObjects];
    
    for (int i = 0; i < self.columnNumbers; i++) {
        [self.maxHeightArray addObject:@0];
    }
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger minColumn = 0;
    CGFloat minColumnHeight = [self.maxHeightArray[0] doubleValue];
    for (NSInteger i = 1; i < self.maxHeightArray.count; i++) {
        if ([self.maxHeightArray[i] doubleValue] < minColumnHeight) {
            minColumnHeight = [self.maxHeightArray[i] doubleValue];
            minColumn = i;
        }
    }
    
    CGFloat w = ( self.collectionView.frame.size.width - self.edgeInserts.left - self.edgeInserts.right - (self.columnNumbers - 1) * self.columnMargin) / self.columnNumbers;
    CGFloat h = [self.delegate collectionViewWaterLayout:self heightForItemAtIndexPath:indexPath withItemWidth:w];
    CGFloat x = self.edgeInserts.left + minColumn * (w + self.columnMargin);
    CGFloat y = 0;
    
    if (minColumnHeight == 0) {
        y = self.edgeInserts.top;
        self.maxHeightArray[minColumn] = @(h);
    }else{
        y = self.edgeInserts.top + minColumnHeight + self.rowMargin;
        self.maxHeightArray[minColumn] = @(h + minColumnHeight + self.rowMargin);
    }
    attrs.frame = CGRectMake(x, y, w, h);
    return attrs;
}

- (CGSize)collectionViewContentSize
{
    CGFloat maxColumnHeight = [self.maxHeightArray[0] doubleValue];
    for (NSInteger i = 1; i < self.maxHeightArray.count; i++) {
        if ([self.maxHeightArray[i] doubleValue] > maxColumnHeight) {
            maxColumnHeight = [self.maxHeightArray[i] doubleValue];
        }
    }
    return CGSizeMake(0, maxColumnHeight + self.edgeInserts.bottom + self.edgeInserts.top);
}

@end
