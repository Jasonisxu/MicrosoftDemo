//
//  CookieHelp.m
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/12.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import "CookieHelp.h"

@implementation CookieHelp

#pragma mark --获取保存cookie--
+ (void)cookieGetAndSaveAction {
    //获取cookie
    NSArray*cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    //把cookie进行归档并转换为NSData类型
    NSData*cookiesData = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    //存储归档后的cookie
    NSUserDefaults*userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: cookiesData forKey: @"cookie"];
}

#pragma mark --删除cookie--
+ (void)cookieDeleteAction {
    NSLog(@"============删除cookie===============");
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    //删除cookie
    for (NSHTTPCookie *tempCookie in cookies) {
        [cookieStorage deleteCookie:tempCookie];
    }
    //把cookie打印出来，检测是否已经删除
    NSArray *cookiesAfterDelete = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *tempCookie in cookiesAfterDelete) {
        NSLog(@"cookieAfterDelete: %@", tempCookie);
    }
}

#pragma mark --取出保存的cookie--
+ (void)cookieGetAction {
    //取出保存的cookie
    NSUserDefaults*userDefaults = [NSUserDefaults standardUserDefaults];
    //对取出的cookie进行反归档处理
    NSArray*cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"cookie"]];
    if(cookies) {
        //设置cookie
        NSHTTPCookieStorage*cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for(NSHTTPCookie * idcookie in cookies) {
            NSLog(@"cookie设置ok:%@",idcookie);
            [cookieStorage setCookie:(NSHTTPCookie*)idcookie];
        }
    }else{
        NSLog(@"cookie设置失败");
    }
}

#pragma mark --全局设置UserAgent--
+ (void)addUserAgentAction {
    
    UIWebView * tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString * oldAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString * newAgent = oldAgent;
    if (![oldAgent hasSuffix:@"panda"])
    {
        newAgent = [oldAgent stringByAppendingString:@"/ wise wisenewshop"];
    }
    NSLog(@"new agent :%@", newAgent);
    
    NSDictionary * dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
@end
