//
//  MSAssetTitleView.h
//  showTime
//
//  Created by msj on 16/10/13.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ArrowDirectionUp,
    ArrowDirectionDown
}ArrowDirection;

@interface MSAssetTitleView : UIView
@property (strong, nonatomic) NSString *title;
@property (copy, nonatomic) void (^changeDirectionBlock)(ArrowDirection direction);

- (void)updateTitle:(NSString *)title;
@end
