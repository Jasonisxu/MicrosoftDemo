//
//  NewWebViewController.m
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/29.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import "NewWebViewController.h"
#import "UmengUtil.h"

@interface NewWebViewController ()<UIWebViewDelegate>
// 外部传来的url
@property (nonatomic, copy) NSString *nowUrlString;
//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;
//员工任务详情分享的url
@property (nonatomic, copy) NSString *taskUrlString;
//判断当前web有没有加载过排行榜
@property (nonatomic, assign) BOOL isHaveRankings;

@end

@implementation NewWebViewController

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    if (!self.nowUrlString) {
//        [self.webView reload];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addLeftButton];
    
    [self addRightButton];
    
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
//        if (self.hidesBottomBarWhenPushed == YES) {
//            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_NAV_HEIGHT)];
//        } else {
//            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_NAV_HEIGHT - SCREEN_TABBAR_HEIGHT)];
//        }
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

    // 当前请求的Url
    NSString *urlString = GetString(request.URL);
    NSLog(@"webUrlString:  %@",urlString);
    NSString *validDomain = GetString(request.URL.host);
    // 请求头的一些信息
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSDictionary *requestHeaders = request.allHTTPHeaderFields;
    //    NSLog(@"requestHeaders:%@",requestHeaders);
    // 请求方式
    NSString *methodString = GetString(request.HTTPMethod);
   //    NSLog(@"HTTPMethod:  %@",methodString);

    return YES;

}

//开始加载网页
- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [HUD showLoadingToView:self.view];
}

//网页加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [HUD hide];
    self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [CookieHelp cookieGetAndSaveAction];
}

//网页加载错误
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [HUD hide];
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

#pragma mark - 添加关闭按钮

- (void)addLeftButton
{
    //同时设置返回按钮和关闭按钮为导航栏左边的按钮
    self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    
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

//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - init

- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //这是一张“<”的图片，可以让美工给切一张
        UIImage *image = [UIImage imageNamed:@"icon-back-white"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        //字体的多少为btn的大小
        [btn sizeToFit];
        //左对齐
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.frame = CGRectMake(0, 0, 60, 40);
        _backItem.customView = btn;
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];
    }
    return _closeItem;
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
