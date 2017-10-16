//
//  MSScanCodeView.h
//  showTime
//
//  Created by msj on 16/9/27.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol MSScanCodeViewDelegate <NSObject>
-(void)ms_scanCodeViewCompleteCallBack:(NSString *)stringValue;
@end

@interface MSScanCodeView : UIView<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,assign)id<MSScanCodeViewDelegate> scanDelegate;
- (void)ms_startScan;
- (void)ms_stopScan;
@end