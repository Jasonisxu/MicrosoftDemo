//
//  ViewController.m
//  CollectHappiness
//
//  Created by Wicrenet_Jason on 2018/3/26.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import "ViewController.h"

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
    [self addDataAction];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addSubView];
    
    [self addUIMasonry];
    
}

#pragma mark - data

- (void)addDataAction {
    
    [self.NewWKVC loadWithUrlString:GetString(@"http://www.hxfpt.com/app/shoppingmall/index_mall.html")];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
