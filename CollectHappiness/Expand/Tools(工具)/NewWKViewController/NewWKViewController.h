//
//  NewWKViewController.h
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/4.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface NewWKViewController : UIViewController
@property (nonatomic, strong) WKWebView *webView;

- (void)loadWithUrlString:(NSString *)urlString;

@end
