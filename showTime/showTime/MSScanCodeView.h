//
//  MSScanCodeView.h
//  showTime
//
//  Created by msj on 16/9/27.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSScanCodeView : UIView
@property (copy, nonatomic) void (^scanCompletionCallBack)(NSString *stringValue);
- (void)ms_startScan;
- (void)ms_stopScan;
@end
