//
//  MSScanCodeView.m
//  showTime
//
//  Created by msj on 16/9/27.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSScanCodeView.h"
#import "MSScanSurfaceView.h"

@interface MSScanCodeView ()<AVCaptureMetadataOutputObjectsDelegate>
@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;

@property (strong, nonatomic) MSScanSurfaceView *surfaceView;
@end

@implementation MSScanCodeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupScanner];
        [self addSurfaceView];
    }
    return self;
}

-(void)setupScanner
{
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeDataMatrixCode,
                                       AVMetadataObjectTypeAztecCode,
                                       AVMetadataObjectTypeQRCode,
                                       AVMetadataObjectTypePDF417Code,
                                       AVMetadataObjectTypeEAN13Code,
                                       AVMetadataObjectTypeEAN8Code,
                                       AVMetadataObjectTypeCode128Code];
    
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.bounds;
    [self.layer insertSublayer:self.preview atIndex:0];
    
}

- (void)addSurfaceView
{
    self.surfaceView = [[MSScanSurfaceView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self setScanRect:self.surfaceView.scanRect];
    [self addSubview:self.surfaceView];
}

-(void)setScanRect:(CGRect)rect
{
    self.output.rectOfInterest = CGRectMake(rect.origin.y/self.frame.size.height, rect.origin.x/self.frame.size.width, rect.size.height/self.frame.size.height, rect.size.width/self.frame.size.width);
}

-(void)ms_startScan
{
    [self.session startRunning];
    [self.surfaceView startBaseLineAnimation];
}

-(void)ms_stopScan
{
    [self.session stopRunning];
    [self.surfaceView stopBaseLineAnimation];
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue = nil;
    
    if (metadataObjects.count > 0){
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [self ms_stopScan];
    
    if ([self.scanDelegate respondsToSelector:@selector(ms_scanCodeViewCompleteCallBack:)]) {
        [self.scanDelegate ms_scanCodeViewCompleteCallBack:stringValue];
    }
    
}

@end
