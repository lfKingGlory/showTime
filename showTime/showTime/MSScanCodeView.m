//
//  MSScanCodeView.m
//  showTime
//
//  Created by msj on 16/9/27.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSScanCodeView.h"
#import "MSScanSurfaceView.h"
#import <AVFoundation/AVFoundation.h>

@interface MSScanCodeView ()<AVCaptureMetadataOutputObjectsDelegate>
@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;

@property (strong, nonatomic) MSScanSurfaceView *surfaceView;
@end

@implementation MSScanCodeView

#pragma mark - Life
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupScanner];
        [self addSurfaceView];
        [self addNotification];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
    [self ms_stopScan];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public
- (void)ms_startScan {
    if (!self.session.isRunning) {
        [self.session startRunning];
        [self.surfaceView startAnimation];
    }
}

- (void)ms_stopScan {
    if (self.session.isRunning) {
        [self.session stopRunning];
        [self.surfaceView stopAnimation];
    }
}

#pragma mark - NSNotification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationWillResignActive {
    [self ms_stopScan];
}

- (void)applicationDidBecomeActive {
    [self ms_startScan];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue = nil;
    if (metadataObjects.count > 0){
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    [self ms_stopScan];
    if (self.scanCompletionCallBack) {
        self.scanCompletionCallBack(stringValue);
    }
    
}

#pragma mark - Private
- (void)setupScanner {
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeDataMatrixCode,
                                        AVMetadataObjectTypeAztecCode,
                                        AVMetadataObjectTypeQRCode,
                                        AVMetadataObjectTypePDF417Code,
                                        AVMetadataObjectTypeEAN13Code,
                                        AVMetadataObjectTypeEAN8Code,
                                        AVMetadataObjectTypeCode128Code];
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.bounds;
    [self.layer insertSublayer:self.preview atIndex:0];
    
}

- (void)addSurfaceView {
    self.surfaceView = [[MSScanSurfaceView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.output.rectOfInterest = self.surfaceView.scanRect;
    [self addSubview:self.surfaceView];
}

@end
