//
//  NewWKViewController.m
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/4.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//



/**
 *   IOS进阶之WKWebView: https://www.jianshu.com/p/4fa8c4eb1316
 */

#import "NewWKViewController.h"
#import "ScanViewController.h"

@interface NewWKViewController ()<WKNavigationDelegate, WKUIDelegate>
// 外部传来的url
@property (nonatomic, copy) NSString *nowUrlString;

@end

@implementation NewWKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

    NSString *header = [[self cookieArrrayAction:request] componentsJoinedByString:@";"];
    [request setValue:header forHTTPHeaderField:@"Cookie"];
    
    WEAK_SELF;
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        CHECK_WEAK_SELF;
        
        NSString *userAgent = result;
        if (![userAgent containsString:@"wise wisenewshop"]) {
            NSString *customUserAgent = [userAgent stringByAppendingString:@" wise wisenewshop"];
            [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelf.webView setCustomUserAgent:customUserAgent];
        }

        [weakSelf.webView loadRequest:request];
    }];
}

- (WKWebView *)webView {
    if (_webView == nil) {
        // 这是创建configuration 的过程
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        //允许视频播放
        configuration.allowsAirPlayForMediaPlayback = YES;
        // 允许在线播放
        configuration.allowsInlineMediaPlayback = YES;
        // 允许可以与网页交互，选择视图
        configuration.selectionGranularity = WKSelectionGranularityDynamic;
        // web内容处理池
        configuration.processPool = [[WKProcessPool alloc] init];
        
        WKPreferences *preferences = [WKPreferences new];
        configuration.preferences = preferences;
        configuration.suppressesIncrementalRendering = YES;
        
        
        NSMutableString* script = [[NSMutableString alloc] init];
        // Get the currently set cookie names in javascriptland
        [script appendString:@"var cookieNames = document.cookie.split('; ').map(function(cookie) { return cookie.split('=')[0] } );\n"];
        
        for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            // Skip cookies that will break our script
            if ([cookie.value rangeOfString:@"'"].location != NSNotFound) {
                continue;
            }
            
            // Create a line that appends this cookie to the web view's document's cookies
            [script appendFormat:@"if (cookieNames.indexOf('%@') == -1) { document.cookie='%@'; };\n", cookie.name, [self javascriptStringWithCookie:cookie]];
        }
        WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:script injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        
        
        // 允许用户更改网页的设置
        WKUserContentController * UserContentController = [[WKUserContentController alloc]init];
        [UserContentController addUserScript:cookieScript];
        
        
        // 是否支持记忆读取
        configuration.suppressesIncrementalRendering = YES;
        // 允许用户更改网页的设置
        configuration.userContentController = UserContentController;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_NAV_HEIGHT) configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.view addSubview:_webView];

    }
    return _webView;
}


- (NSString *)javascriptStringWithCookie:(NSHTTPCookie*)cookie {
    
    NSString *string = [NSString stringWithFormat:@"%@=%@;domain=%@;path=%@",
                        cookie.name,
                        cookie.value,
                        cookie.domain,
                        cookie.path ?: @"/"];
    
    if (cookie.secure) {
        string = [string stringByAppendingString:@";secure=true"];
    }
    
    return string;
}

#pragma mark - WKNavigationDelegate

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [CookieHelp cookieGetAndSaveAction];
    [self addTDSDKACtion];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

#pragma mark ================ WKWebView的javascript alert 不弹的解决方案 ================

// 拦截警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

// 拦截确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 拦截提示框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark ================ cookieArray ================

- (NSMutableArray *)cookieArrrayAction:(NSURLRequest *)request {
    
    NSString *validDomain = GetString(request.URL.host);
    const BOOL requestIsSecure = [request.URL.scheme isEqualToString:@"https"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        // Don't even bother with values containing a `'`
        if ([cookie.name rangeOfString:@"'"].location != NSNotFound) {
            //                    NSLog(@"Skipping %@ because it contains a '", cookie.properties);
            continue;
        }
        
        // Is the cookie for current domain?
        if (![cookie.domain hasSuffix:validDomain]) {
            //                    NSLog(@"Skipping %@ (because not %@)", cookie.properties, validDomain);
            continue;
        }
        
        // Are we secure only?
        if (cookie.secure && !requestIsSecure) {
            //                    NSLog(@"Skipping %@ (because %@ not secure)", cookie.properties, request.URL.absoluteString);
            continue;
        }
        
        NSString *value = [NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value];
        [array addObject:value];
    }
    
    return array;
}

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

