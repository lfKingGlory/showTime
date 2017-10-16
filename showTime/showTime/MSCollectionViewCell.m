//
//  MSCollectionViewCell.m
//  showTime
//
//  Created by msj on 16/8/29.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface MSCollectionViewCell ()
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation MSCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)setGoodsModel:(MSGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.img] placeholderImage:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

@end
