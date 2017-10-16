//
//  MSDelegate.h
//  showTime
//
//  Created by msj on 2017/1/10.
//  Copyright © 2017年 msj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MSDelegate : NSObject<UITableViewDelegate>
@property (weak, nonatomic) id firstDelegate;
@property (weak, nonatomic) id secondDelegate;
@end
