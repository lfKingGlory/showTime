//
//  MSPhotoSelectorCell.m
//  showTime
//
//  Created by msj on 16/10/12.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSPhotoSelectorCell.h"

@interface MSPhotoSelectorCell ()
@property (strong, nonatomic) UIImageView *imageview;
@end

@implementation MSPhotoSelectorCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.exclusiveTouch = YES;
        
        self.imageview = [[UIImageView alloc] init];
        self.imageview.contentMode = UIViewContentModeScaleAspectFill;
        self.imageview.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageview];
        
    }
    return self;
}

- (void)setPhAsset:(id)phAsset
{
    if ([phAsset isKindOfClass:[PHAsset class]]) {
        _phAsset = phAsset;
        CGSize size = self.frame.size;
        size.width *= [UIScreen mainScreen].scale;
        size.height *= [UIScreen mainScreen].scale;
        [MSAssetUtil getImageByAsset:phAsset makeSize:size makeResizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *assetImage) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageview.image = assetImage;
            });
            
        }];
    }else{
        self.imageview.image = [UIImage imageNamed:@"camera"];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageview.frame = self.bounds;
}
@end
