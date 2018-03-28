//
//  ReadableCodeScanView.m
//  clientsAPP
//
//  Created by Cator Vee on 05/09/2017.
//  Copyright © 2017 Wicrenet_Jason. All rights reserved.
//

#import "ReadableCodeScanView.h"
#import "ReadableCodeMaskView.h"

@interface ReadableCodeScanView () <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic) id<ReadableCodeScanViewDelegate> delegate;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,strong) ReadableCodeMaskView *maskView;
@end

@implementation ReadableCodeScanView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithDelegate:(id<ReadableCodeScanViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    self.maskView = [[ReadableCodeMaskView alloc] init];
    [self addSubview:self.maskView];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error != nil) {
        return;
    }
    
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code]];
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = [UIScreen mainScreen].bounds;
    [self.layer insertSublayer:self.previewLayer atIndex:0];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.maskView.frame = self.bounds;
}

-(void)startScanning
{
    if (self.session != nil) {
        self.previewLayer.frame = self.bounds;
        [self.session startRunning];
    }
    if (self.maskView != nil) {
        [self.maskView startAnimating];
    }
}

-(void)stopScanning
{
    if (self.session != nil) {
        [self.session stopRunning];
    }
    if (self.maskView != nil) {
        [self.maskView stopAnimating];
    }
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count == 0) {
        return;
    }
    
    if (self.delegate == nil && [self.delegate respondsToSelector:@selector(scanView:metadata:)] == NO) {
        return;
    }
    
    AVMetadataMachineReadableCodeObject *metadata = metadataObjects[0];
    [self.delegate scanView:self metadata:metadata];
}

@end
