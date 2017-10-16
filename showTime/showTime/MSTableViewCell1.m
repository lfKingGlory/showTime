//
//  MSTableViewCell1.m
//  showTime
//
//  Created by msj on 16/8/24.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSTableViewCell1.h"
#import "MSProgressView.h"

@interface MSTableViewCell1 ()
@property (strong, nonatomic) MSProgressView *progressView;
@end

@implementation MSTableViewCell1

- (instancetype)initWithFrame:(CGRect)frame  style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.progressView = [[MSProgressView alloc] initWithFrame:CGRectMake(20, (frame.size.height - 3)/2.0, frame.size.width - 40, 3)];
        self.progressView.progressViewType = MSProgressViewType_showPreogressButton;
        [self.contentView addSubview:self.progressView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
  
    self.progressView.progress = progress;
}


@end
