//
//  ViewController.m
//  CollectHappiness
//
//  Created by Wicrenet_Jason on 2018/3/26.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import "ViewController.h"
#import "NewWKViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NewWebViewController *NewWKVC;

@end

@implementation ViewController

#pragma mark - LazyLoad

- (NewWebViewController *)NewWKVC {
    if (!_NewWKVC) {
        _NewWKVC = [NewWebViewController new];
        
        [self addChildViewController:_NewWKVC];
    }
    return _NewWKVC;
}

#pragma mark - subView

- (void)addSubView {
    [self.view addSubview:self.NewWKVC.view];
}

#pragma mark - Masonry

- (void)addUIMasonry {
    [_NewWKVC.view setFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarHeight)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self monitorNetworking];
    
    [self addTDSDKAction];
    
    [self addSubView];
    
    [self addUIMasonry];
    
    [self addDataAction];
}

#pragma mark - data

- (void)addDataAction {
    
//    [self.NewWKVC loadWithUrlString:GetString(@"http:///hiiso.xicp.cn:8060/app/shoppingmall/index_mall.html")];
    [self.NewWKVC loadWithUrlString:GetString(@"http://www.hxfpt.com/app/shoppingmall/index_mall.html")];

}

- (void)addTDSDKAction {
    // 获取设备管理器实例
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    
    // 准备SDK初始化参数
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    /*
     * SDK具有防调试功能，当使用xcode运行时(开发测试阶段),请取消下面代码注释，
     * 开启调试模式,否则使用xcode运行会闪退。上架打包的时候需要删除或者注释掉这
     * 行代码,如果检测到调试行为就会触发crash,起到对APP的保护作用
     */
    // 上线Appstore的版本，请记得删除此行，否则将失去防调试防护功能！
    [options setValue:@"allowd" forKey:@"allowd"];  // TODO
    
    // 指定对接同盾的测试环境，正式上线时，请删除或者注释掉此行代码，切换到同盾生产环境
    [options setValue:@"sandbox" forKey:@"env"]; // TODO
    
    // 此处已经替换为您的合作方标识了
    [options setValue:@"yintaokj" forKey:@"partner"];
    
    // 使用上述参数进行SDK初始化
    manager->initWithOptions(options);
}


#pragma mark - ------------- 监测网络状态 -------------
- (void)monitorNetworking
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可达");
                break;
            case 1:
            {
                NSLog(@"GPRS网络");
                [self.NewWKVC.webView reload];
            }
                break;
            case 2:
            {
                NSLog(@"wifi网络");
                [self.NewWKVC.webView reload];
            }
                break;
            default:
                break;
        }
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"有网");
        }else{
            NSLog(@"没网");
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
