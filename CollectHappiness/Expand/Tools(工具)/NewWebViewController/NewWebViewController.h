//
//  NewWebViewController.h
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/29.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface NewWebViewController : UIViewController
@property (nonatomic, strong) UIWebView *webView;

- (void)loadWithUrlString:(NSString *)urlString;

@end
