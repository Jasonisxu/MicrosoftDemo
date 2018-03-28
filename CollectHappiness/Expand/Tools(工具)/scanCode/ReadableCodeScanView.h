//
//  ReadableCodeScanView.h
//  clientsAPP
//
//  Created by Cator Vee on 05/09/2017.
//  Copyright © 2017 Wicrenet_Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class ReadableCodeScanView;

@protocol ReadableCodeScanViewDelegate <NSObject>
@optional
-(void)scanView:(ReadableCodeScanView *)scanView metadata:(AVMetadataMachineReadableCodeObject *)metadata;
@end

@interface ReadableCodeScanView : UIView

-(instancetype)initWithDelegate:(id<ReadableCodeScanViewDelegate>)delegate;
-(void)startScanning;
-(void)stopScanning;

@end
