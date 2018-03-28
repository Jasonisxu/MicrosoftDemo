//
//  ScanViewController.m
//  CollectHappiness
//
//  Created by Wicrenet_Jason on 2018/3/28.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import "ScanViewController.h"
#import "ReadableCodeScanView.h"

@interface ScanViewController ()<ReadableCodeScanViewDelegate>
@property (nonatomic, strong) ReadableCodeScanView *scanView;

@end

@implementation ScanViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.scanView != nil) {
        [self.scanView startScanning];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addRightButton];
    
    
    [self addScanViewACtion];
}


- (void)addRightButton {
    
    //添加右边刷新按钮-----变为分享
    WEAK_SELF;
    [weakSelf setRightImageBarButtonItemImage:@"关闭" action:^(LXButton *button) {
        CHECK_WEAK_SELF;
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark --添加扫码界面--

- (void)addScanViewACtion {
#if TARGET_IPHONE_SIMULATOR
    
    [HUD showLoadingToView:self.view withMessage:@"模拟器中不支持扫码功能"];
    
#else
    [self addReadableCodeScanView];
#endif
    
}

- (void)addReadableCodeScanView {
    self.scanView = [[ReadableCodeScanView alloc] initWithDelegate:self];
    [self.view addSubview:self.scanView];
    
    [self.scanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

-(void)scanView:(ReadableCodeScanView *)scanView metadata:(AVMetadataMachineReadableCodeObject *)metadata {
    LOG_D("扫描识别结果: type=%@ value=%@", metadata.type, metadata.stringValue);
    [scanView stopScanning];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
