//
//  MSPhotoAblumCell.m
//  showTime
//
//  Created by msj on 16/10/12.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSPhotoAblumCell.h"

@interface MSPhotoAblumCell ()
@property (strong, nonatomic) UIImageView *imageview;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIView *bottomLine;
@end

@implementation MSPhotoAblumCell
+ (MSPhotoAblumCell *)cellWithTableView:(UITableView *)tableView
{
    MSPhotoAblumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSPhotoAblumCell"];
    if (!cell) {
        cell = [[MSPhotoAblumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MSPhotoAblumCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.exclusiveTouch = YES;
        
        self.imageview = [[UIImageView alloc] init];
        self.imageview.contentMode = UIViewContentModeScaleAspectFill;
        self.imageview.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageview];
        
        self.title = [[UILabel alloc] init];
        self.title.font = [UIFont systemFontOfSize:15];
        self.title.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.title];
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = [UIColor colorWithRed:241/256.0 green:241/256.0 blue:241/256.0 alpha:1];
        [self.contentView addSubview:self.bottomLine];
        
    }
    return self;
}

- (void)setAssetModel:(MSAssetModel *)assetModel
{
    _assetModel = assetModel;
    self.title.text = [NSString stringWithFormat:@"%@(%ld)",assetModel.title,(long)assetModel.photoNumber];
    CGSize size = CGSizeMake(60, 60);
    size.width *= [UIScreen mainScreen].scale;
    size.height *= [UIScreen mainScreen].scale;
    [MSAssetUtil getImageByAsset:assetModel.firstAsset makeSize:size makeResizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *assetImage) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageview.image = assetImage;
        });
        
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageview.frame = CGRectMake(10, (self.frame.size.height - 60)/2.0, 60, 60);
    self.title.frame = CGRectMake(CGRectGetMaxX(self.imageview.frame) + 10, 0, self.frame.size.width - (CGRectGetMaxX(self.imageview.frame) + 20), self.frame.size.height);
    self.bottomLine.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
}
@end
