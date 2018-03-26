//
//  CookieHelp.h
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/12.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CookieHelp : NSObject

#pragma mark --获取保存cookie--
+ (void)cookieGetAndSaveAction;

#pragma mark --删除cookie--
+ (void)cookieDeleteAction;

#pragma mark --取出保存的cookie--
+ (void)cookieGetAction;

#pragma mark --全局设置UserAgent--
+ (void)addUserAgentAction;

@end
