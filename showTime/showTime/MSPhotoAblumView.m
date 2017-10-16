//
//  MSPhotoAblumView.m
//  showTime
//
//  Created by msj on 16/10/12.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSPhotoAblumView.h"
#import "MSPhotoAblumCell.h"
#define tableViewHeight   350

@interface MSPhotoAblumView ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation MSPhotoAblumView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -tableViewHeight, self.frame.size.width, tableViewHeight) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 80;
        [self addSubview:self.tableView];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        
    }
    return self;
}

- (void)setPhotoAblumArrM:(NSMutableArray<MSAssetModel *> *)photoAblumArrM
{
    _photoAblumArrM = photoAblumArrM;
    [self.tableView reloadData];
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview == nil) {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.tableView.transform = CGAffineTransformMakeTranslation(0, tableViewHeight);
    }];
    
}
- (void)removeFromSuperview
{
    [UIView animateWithDuration:0.25 animations:^{
       self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.tableView.transform = CGAffineTransformMakeTranslation(0, -tableViewHeight);
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
    
}

#pragma mark - UITouch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ms_photoAblumView:didSelectAssetModel:)]) {
        [self.delegate ms_photoAblumView:self didSelectAssetModel:nil];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photoAblumArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSPhotoAblumCell *cell = [MSPhotoAblumCell cellWithTableView:tableView];
    cell.assetModel = self.photoAblumArrM[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ms_photoAblumView:didSelectAssetModel:)]) {
        [self.delegate ms_photoAblumView:self didSelectAssetModel:self.photoAblumArrM[indexPath.row]];
    }
}
@end
