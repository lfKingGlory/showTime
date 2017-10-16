//
//  MSProgressView.h
//  showTime
//
//  Created by msj on 16/8/24.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MSProgressViewType_showProgressLabel,
    MSProgressViewType_showPreogressButton
}MSProgressViewType;

@interface MSProgressView : UIView
/*
 * progress < 0        -->>  显示  0%
 * 0 <= progress < 1   -->>  0% <=  显示 < 100%
 * 1 <= progress < 10  -->>  100% <=  显示 < 1000%
 * 10 <= progress      -->>  显示  ≥999%
 */
@property (assign, nonatomic) CGFloat progress;
@property (assign, nonatomic) MSProgressViewType progressViewType;
@end