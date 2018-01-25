//
//  MSViewController3.m
//  showTime
//
//  Created by msj on 16/8/18.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSViewController3.h"
#import "BBMCollectionViewWaterLayout.h"
#import "MSCollectionViewCell.h"
#import "MSGoodsModel.h"
#import "MSPhotoController.h"
#import "MSPhotoItem.h"
#import "MSLoadingView.h"

@interface MSViewController3 ()<UICollectionViewDataSource, BBMCollectionViewWaterLayoutDelegate, UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) MSLoadingView *loadingView;
@end

@implementation MSViewController3
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BBMCollectionViewWaterLayout *layout = [[BBMCollectionViewWaterLayout alloc] init];
    layout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
//    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[MSCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    self.dataArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        MSGoodsModel *model = [[MSGoodsModel alloc] init];
        model.price = dic[@"price"];
        model.img = dic[@"img"];
        model.w = dic[@"w"];
        model.h = dic[@"h"];
        [self.dataArr addObject:model];
    }
    [self.collectionView reloadData];
    
    self.loadingView = [[MSLoadingView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) * 0.5, (self.view.frame.size.height - 50) * 0.5, 50, 50)];
    self.loadingView.loadingViewType = MSLoadingViewType_line;
    [self.view addSubview:self.loadingView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.loadingView.progress = 0.35;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.goodsModel = self.dataArr[indexPath.row];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    MSPhotoController *vc = [[MSPhotoController alloc] init];
//    vc.type = MSPhotoController_present;
//    NSMutableArray *arr = [NSMutableArray array];
//    for (int i = 0; i < self.dataArr.count; i++) {
//        MSPhotoItem *item = [[MSPhotoItem alloc] init];
//        MSGoodsModel *model = self.dataArr[i];
//        item.thumbnail_pic = model.img;
//        [arr addObject:item];
//    }
//    vc.photoItems = arr;
//    vc.currentIndex = (int)indexPath.item;
//    
//    
//    /*
//     
//     UIModalTransitionStyleCoverVertical = 0,
//     UIModalTransitionStyleFlipHorizontal __TVOS_PROHIBITED,
//     UIModalTransitionStyleCrossDissolve,
//     UIModalTransitionStylePartialCurl NS_ENUM_AVAILABLE_IOS(3_2) __TVOS_PROHIBITED,
//     */
//    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self.navigationController presentViewController:vc animated:YES completion:^{
//        
//    }];
}

#pragma mark - BBMCollectionViewWaterLayoutDelegate
- (CGFloat)collectionViewWaterLayout:(BBMCollectionViewWaterLayout *)collectionViewWaterLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath withItemWidth:(CGFloat)itemWidth
{
    MSGoodsModel *goodsModel = self.dataArr[indexPath.row];
    return goodsModel.h.doubleValue / goodsModel.w.doubleValue * itemWidth;
}

- (NSInteger)columnNumbersInBBMCollectionViewWaterLayout:(BBMCollectionViewWaterLayout *)collectionViewWaterLayout
{
    return 2;
}
- (CGFloat)columMarginInBBMCollectionViewWaterLayout:(BBMCollectionViewWaterLayout *)collectionViewWaterLayout
{
    return 5;
}
- (CGFloat)rowMarginInBBMCollectionViewWaterLayout:(BBMCollectionViewWaterLayout *)collectionViewWaterLayout
{
    return 5;
}
- (UIEdgeInsets)edgeInsertsInBBMCollectionViewWaterLayout:(BBMCollectionViewWaterLayout *)collectionViewWaterLayout
{
    return UIEdgeInsetsMake(5, 0, 5, 0);
}
@end
