//
//  UmengUtil.h
//  SmallShops-seller-iOS
//
//  Created by Wicrenet_Jason on 2017/3/23.
//  Copyright © 2017年 Wicrenet_Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>

static const int TARGET_WECHAT_SESSION  = 0;
static const int TARGET_WECHAT_TIMELINE = 1;
static const int TARGET_QQ              = 2;
static const int TARGET_QZONE           = 3;
static const int TARGET_SINA            = 4;
static const int TARGET_COPYLINK        = 5;
static const int TARGET_SMS             = 6;

@interface UmengUtil : NSObject
+ (void)shareBoardBySelfDefinedController:(UIViewController *)controller photoURL:(NSString *)photoURL titleStr:(NSString *)titleStr descrStr:(NSString *)descrStr shareURL:(NSString *)shareURL;
@end
