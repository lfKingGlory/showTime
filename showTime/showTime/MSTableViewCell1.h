//
//  MSTableViewCell1.h
//  showTime
//
//  Created by msj on 16/8/24.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTableViewCell1 : UITableViewCell

- (instancetype)initWithFrame:(CGRect)frame  style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property (assign, nonatomic) CGFloat progress;

@end
