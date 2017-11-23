//
//  MSScanViewcontroller.m
//  showTime
//
//  Created by msj on 16/9/28.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSScanViewcontroller.h"
#import "MSScanCodeView.h"
#import "UIView+FrameUtil.h"
#import "MSViewController5.h"
#import "UINavigationController+removeAtIndex.h"

@interface MSScanViewcontroller ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) MSScanCodeView *scanCodeView;
@end

@implementation MSScanViewcontroller
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scanCodeView = [[MSScanCodeView alloc] initWithFrame:self.view.bounds];
    __weak typeof(self) weakSelf = self;
    self.scanCodeView.scanCompletionCallBack = ^(NSString *stringValue) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"%@",stringValue);
        MSViewController5 *v = [[MSViewController5 alloc] init];
        v.message = stringValue;
        [strongSelf.navigationController pushViewController:v animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.navigationController removeViewcontrollerAtIndex:strongSelf.navigationController.viewControllers.count - 2];
        });
    };
    [self.view addSubview:self.scanCodeView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"从相册获取" style:UIBarButtonItemStylePlain target:self action:@selector(tap)];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.scanCodeView ms_startScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanCodeView ms_stopScan];
}

- (void)tap {
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请更新系统至8.0以上!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            
            UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
            pickerC.delegate = self;
            pickerC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:pickerC animated:YES completion:nil];
            
        }else{
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count > 0) {
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            
            MSViewController5 *v = [[MSViewController5 alloc] init];
            v.message = scannedResult;
            [self.navigationController pushViewController:v animated:YES];
            [self.navigationController removeViewcontrollerAtIndex:self.navigationController.viewControllers.count - 2];
            
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
    }];
    
}
@end
