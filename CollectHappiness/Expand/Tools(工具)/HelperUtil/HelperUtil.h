//
//  HelperUtil.h
//  SQLite（购物）
//
//  Created by Yock Deng on 15/8/22.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MapObject;

@interface HelperUtil : NSObject
//将JSON串转化为字典或者数组
+ (id)toArrayOrNSDictionary:(NSString *)jsonData;

+ (NSString *)htmlShuangyinhao:(NSString *)values;

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (NSString *)distanceTimeWithBeforeTime:(double)beTime;
// 字符串转为字典
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString ;

//数组转为字符串
+(NSString*)parseArrayToStr:(id)arr;

//拼接Document目录中的文件路径
+(NSString *)fileByDocumentPath:(NSString *)fileName;

//检查密码的合法性
+ (BOOL)checkPassword:(NSString *)password;

// 时间戳转为字符串的时间
+ (NSString*)timeStamp2Date:(NSString*)timeStamp;
+ (NSString *)distanceTimeWithBeforeTimeForNotice:(NSString *)strTimw;

//手机号码验证
+ (BOOL) isMobile:(NSString *)mobileNumbel;

//下单时间
+ (NSString *)orderTimeWithBeforeTime:(NSString *)nowTime;

//版本更新
+ (void)VersionUpdate:(UIViewController *)controller;

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;
//获取当前屏幕中present出来的viewcontroller。
+ (UIViewController *)getPresentedViewController;

/**
 * 生成GUID
 */
+ (NSString *)generateUuidString;

//字典转Json
+(NSString*)dicToJson:(NSDictionary *)dic;

//数组转Json
+(NSString*)arrayToJson:(NSMutableArray *)array;

//字符串转化为时间戳
+ (NSString *)stringChangeTimeinterval:(NSString *)strTime;

//用对象的方法计算文本的大小
+ (CGSize)sizeWithString:(NSString*)str andFont:(UIFont*)font  andMaxSize:(CGSize)size;

//高斯模糊
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
//图片旋转90度
+ (UIImage *)fixOrientation:(UIImage *)aImage;
/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr;

// 格式化货币
+ (NSString *)stringForCurrency:(float)currency keepZero:(BOOL)keepZero;
+ (NSString *)stringNoYForCurrency:(float)currency keepZero:(BOOL)keepZero;

// 将货币格式化，并设置给UILabel
+ (void)setLabel:(UILabel *)label withCurrency:(float)currency keepZero:(BOOL)keepZero;

// 微信支付本地签名
+ (NSString *)createMD5SingForPayWithAppID:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key;

// 根据ID获取可重用的TableViewCell
+ (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forTableView:(UITableView *)tableView;

// 打开链接，链接可能是 网址、商品、商品主题 中的一种
+ (void)openSmartLink:(MapObject *)link toViewController:(UIViewController *)viewController;

@end
