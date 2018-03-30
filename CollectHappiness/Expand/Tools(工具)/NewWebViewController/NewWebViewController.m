//
//  NewWebViewController.m
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/29.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import "NewWebViewController.h"
#import "UmengUtil.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ScanViewController.h"

@interface NewWebViewController ()<UIWebViewDelegate>
// 外部传来的url
@property (nonatomic, copy) NSString *nowUrlString;
//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;
//员工任务详情分享的url
@property (nonatomic, copy) NSString *taskUrlString;

@end

@implementation NewWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 添加轻扫手势
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backNative)];
    [rightSwipe setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.webView addGestureRecognizer:rightSwipe];
}

#pragma mark - Masonry

- (void)addUIMasonry {
    // scrollView设置不通的状态，显示会有不同的区别
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}



- (void)loadWithUrlString:(NSString *)urlString{
    
    //发送的链接的参数中如果带有中文，那么首先就需要调用这个方法把编码方式改为utf8，因为服务器端一般都使用utf8编码
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (url == nil) {
        [HUD showErrorMessage:@"无效的链接地址" toView:nil];
        return;
    }
    self.nowUrlString = urlString;
    
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [self addUIMasonry];
}

- (UIWebView *)webView {
    if (_webView == nil) {
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.backgroundColor = WHITE_COLOR;
        _webView.delegate = self;
        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_webView];
        
    }
    return _webView;
}

#pragma mark - UIWebViewDelegate代理方法
#pragma mark 开始加载
//是否允许加载网页，也可获取js要打开的url，通过截取此url可与js交互
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}


//网页加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [CookieHelp cookieGetAndSaveAction];
    [self addTDSDKACtion];

    
    WEAK_SELF;
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //定义好JS要调用的方法，finish就是调用的方法名
    context[@"iosScanCode"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [weakSelf goScanViewAction];
           
        });
    };
    
    
//    context[@"share"] = ^() {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"方式二" message:@"这是OC原生的弹出窗" delegate:self cancelButtonTitle:@"收到" otherButtonTitles:nil];
//            [alertView show];
//        });
//    };
  
}


#pragma mark - 添加分享按钮

- (void)addRightButton {
    
    //添加右边刷新按钮-----变为分享
    WEAK_SELF;
    [weakSelf setRightImageBarButtonItemImage:@"分享" action:^(LXButton *button) {
        CHECK_WEAK_SELF;
        
        
        weakSelf.taskUrlString = [weakSelf.webView stringByEvaluatingJavaScriptFromString:@"shareData.wxData.link"];
        NSLog(@"taskUrlString    %@",weakSelf.taskUrlString);
        
        
        if ([weakSelf.webView.request.URL.absoluteString containsString:@"app/taskapp/detail"]) {
            weakSelf.taskUrlString = [weakSelf.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('taskUrl').href"];
            NSLog(@"taskUrlString    %@",weakSelf.taskUrlString);
        }
        
        
        
        if (![GetString(weakSelf.taskUrlString) isEqualToString:@""]) {
            [UmengUtil shareBoardBySelfDefinedController:weakSelf photoURL:IMAGE_USER_HEADIMG titleStr:weakSelf.title descrStr:@"" shareURL:GetString(weakSelf.taskUrlString)];
        } else {
            [UmengUtil shareBoardBySelfDefinedController:weakSelf photoURL:IMAGE_USER_HEADIMG titleStr:weakSelf.title descrStr:@"" shareURL:GetString(weakSelf.webView.request.URL.absoluteString)];
        }
        
    }];
}




//点击返回的方法
- (void)backNative
{
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - 设备指纹

- (void)addTDSDKACtion {
    // 获取设备管理器实例
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    
    /*
     * 获取设备指纹黑盒数据，请确保在应用开启时已经对SDK进行初始化，切勿在get的时候才初始化
     * 如果此处获取到的blackBox特别长(超过400字节)，说明初始化尚未完成(一般需要1-3秒)，或者由于网络问题导致初始化失败，进入了降级处理
     * 降级不影响正常设备信息的获取，只是会造成blackBox字段超长，且无法获取设备真实IP
     * 降级数据平均长度在2KB以内,一般不超过3KB,数据的长度取决于采集到的设备信息的长度,无法100%确定最大长度
     */
    NSString *blackBox = manager->getDeviceInfo();
    NSLog(@"同盾设备指纹数据: %@", blackBox);
    // 将blackBox随业务请求提交到您的服务端，服务端调用同盾风险决策API时需要带上这个参数
}



#pragma mark - 扫码
- (void)goScanViewAction {
    WEAK_SELF;
    JSContext *context = [weakSelf.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    ScanViewController *ScanVC = [ScanViewController new];
    [ScanVC setAddProductNoBlock:^(NSString *productNoString) {
        NSString *jscript = [NSString stringWithFormat:@"jumpApplyStaging(\"%@\")",productNoString];
        // 调用JS代码
        [context evaluateScript:jscript];
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ScanVC];
    [weakSelf presentViewController:nav animated:YES completion:nil];
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
