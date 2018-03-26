//
//  config.h
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/3.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#ifndef config_h
#define config_h

/*******************************************************************************************************************/
#define IPHONE5OR5SORSE [[UIScreen mainScreen] bounds].size.width == 320
#define IPHONE6OR6S  [[UIScreen mainScreen] bounds].size.width ==375
#define IPHONE6OR6S_PLUSS [[UIScreen mainScreen] bounds].size.width>375
#define IPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)

// 屏幕高和宽
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define ONEPX           (1.0f / [UIScreen mainScreen].scale)
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define KTabbarHeight_Before 49
#define BottomForHome (SCREEN_TABBAR_HEIGHT - KTabbarHeight_Before)
// 屏幕tabbar的高度
#define SCREEN_TABBAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
// 屏幕navigation的高度
#define SCREEN_NAV_HEIGHT (kStatusBarHeight + kNavBarHeight)


/*******************************************************************************************************************/
// NSLog语句注释掉 ,在release下
#ifndef __OPTIMIZE__
#define NSLog(format, ...) do {                                             \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "------------------------------\n");                        \
} while (0)
#else
#define NSLog(...) {}
#endif

/*******************************************************************************************************************/
//RCNSUserDefaults
#define LXUserDefaultsSet(value,key) [[NSUserDefaults standardUserDefaults] setValue:value forKey:key]
#define LXUserDefaultsGet(key) [[NSUserDefaults standardUserDefaults] valueForKey:key]

//获取图片资源
#define GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
//转化为String
#define GetString(string) string ? [NSString stringWithFormat:@"%@",string] ? [NSString stringWithFormat:@"%@",string] : @"" : @""
//转换为float
#define GetFloat(obj, defaultValue) (obj == nil ? defaultValue : [obj floatValue])

/*******************************************************************************************************************/
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define MAIN_COLOR    [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",LXUserDefaultsGet(MainColorString)] alpha:1]
#define Gray_System_Dividing_Line_Color  RGB(238, 238, 238)//分割线
#define Gray_System_Base_Color RGB(248, 248, 248)//底色
#define WHITE_COLOR  [UIColor whiteColor]
#define BLACK_COLOR  [UIColor blackColor]
#define LightGrayColor_COLOR  [UIColor lightGrayColor]

/*******************************************************************************************************************/
#define MAS_SHORTHAND

#define PFR20Font [UIFont systemFontOfSize:20]
#define PFR18Font [UIFont systemFontOfSize:18]
#define PFR16Font [UIFont systemFontOfSize:16]
#define PFR15Font [UIFont systemFontOfSize:15]
#define PFR14Font [UIFont systemFontOfSize:14]
#define PFR13Font [UIFont systemFontOfSize:13]
#define PFR12Font [UIFont systemFontOfSize:12]
#define PFR11Font [UIFont systemFontOfSize:11]
#define PFR10Font [UIFont systemFontOfSize:10]

#endif /* config_h */
