//
//  MSPhotoSelectorController.m
//  showTime
//
//  Created by msj on 16/10/12.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSPhotoSelectorController.h"
#import "MSPhotoViewController.h"
#import "MSPhotoSelectorCell.h"
#import "MSPhotoAblumView.h"
#import "MSAssetTitleView.h"

#define margin  5
#define screenWidth   [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height


@interface MSPhotoSelectorController ()<UICollectionViewDelegate, UICollectionViewDataSource, MSPhotoAblumViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) MSAssetTitleView *titleView;
@property (strong, nonatomic) MSPhotoAblumView *photoAblumView;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) NSMutableArray *photoArrM;
@property (strong, nonatomic) NSMutableArray <MSAssetModel *>*photoAblumArrM;
@end

@implementation MSPhotoSelectorController

- (MSPhotoAblumView *)photoAblumView
{
    if (!_photoAblumView) {
        _photoAblumView = [[MSPhotoAblumView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
        _photoAblumView.delegate = self;
    }
    return _photoAblumView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNotifications];
    [self addRightBarButtonItem];
    [self addTitleView];
    [self updateDataSource];
    [self addCollectionView];
    
}


- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel) name:UIApplicationDidEnterBackgroundNotification object:nil];
}
- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addRightBarButtonItem
{
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    cancelBtn.showsTouchWhenHighlighted = YES;
    cancelBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
}

- (void)cancel
{
    if (self.photoAblumView.superview) {
        [self.photoAblumView removeFromSuperview];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)showTipsWithMessage:(NSString *)message
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addTitleView
{
    __weak typeof(self) weakSelf = self;
    self.titleView = [[MSAssetTitleView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    self.navigationItem.titleView = self.titleView;
    self.titleView.changeDirectionBlock = ^(ArrowDirection direction) {
        if (direction == ArrowDirectionUp) {
            weakSelf.photoAblumView.photoAblumArrM = weakSelf.photoAblumArrM;
            [weakSelf.view addSubview:weakSelf.photoAblumView];
        }else if(direction == ArrowDirectionDown){
            [weakSelf.photoAblumView removeFromSuperview];
        }
    };
}

- (void)updateDataSource
{
    self.photoAblumArrM = [MSAssetUtil getAllAssetModel];
    for (MSAssetModel *model in self.photoAblumArrM) {
        if ([model.title isEqualToString:@"相机胶卷"] && model.assetCollection.assetCollectionType == PHAssetCollectionTypeSmartAlbum) {
            self.photoArrM = [MSAssetUtil getAssetsInAssetCollection:model.assetCollection ascending:NO];
            [self.photoArrM insertObject:[[NSObject alloc] init] atIndex:0];
            self.titleView.title = model.title;
            break;
        }
    }
}

- (void)addCollectionView
{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (screenWidth - 5 * margin) / 4;
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[MSPhotoSelectorCell class] forCellWithReuseIdentifier:@"MSPhotoSelectorCell"];
    
    [self.collectionView reloadData];
    
}

#pragma mark - MSPhotoAblumViewDelegate
- (void)ms_photoAblumView:(MSPhotoAblumView *)photoAblumView didSelectAssetModel:(MSAssetModel *)assetModel
{
    [self.photoAblumView removeFromSuperview];
    if (assetModel) {
        [self.titleView updateTitle:assetModel.title];
        self.photoArrM = [MSAssetUtil getAssetsInAssetCollection:assetModel.assetCollection ascending:NO];
        if ([assetModel.title isEqualToString:@"相机胶卷"] && assetModel.assetCollection.assetCollectionType == PHAssetCollectionTypeSmartAlbum) {
            [self.photoArrM insertObject:[[NSObject alloc] init] atIndex:0];
        }
        [self.collectionView reloadData];
    }else{
        [self.titleView updateTitle:self.titleView.title];
    }
}

#pragma mark - UICollectionViewDelegate   UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArrM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSPhotoSelectorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSPhotoSelectorCell" forIndexPath:indexPath];
    cell.phAsset = self.photoArrM[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.photoArrM[indexPath.item];
    if ([model isKindOfClass:[PHAsset class]]) {
        __weak typeof(self) weakSelf = self;
        MSPhotoViewController *photoViewController = [[MSPhotoViewController alloc] init];
        photoViewController.phAsset = self.photoArrM[indexPath.item];
        photoViewController.block = ^(UIImage *image){
            if (weakSelf.callBlack) {
                weakSelf.callBlack(image);
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        [self.navigationController pushViewController:photoViewController animated:YES];
    }else{
        if ([MSAssetUtil isCameraAuthority]) {
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.picker.delegate = self;
            [self presentViewController:self.picker animated:YES completion:^{

            }];
        }else{
            [self showTipsWithMessage:@"请在iPhone的\"设置-隐私-相机\"中允许访问相机"];
        }
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (!success) return ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateDataSource];
            [self.collectionView reloadData];
        });
    }];
    [self.picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)dealloc
{
    [self removeNotifications];
    NSLog(@"%s",__func__);
}

@end
