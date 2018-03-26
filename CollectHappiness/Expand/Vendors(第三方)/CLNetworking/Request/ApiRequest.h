//
// Created by Cator Vee on 13/09/2017.
// Copyright (c) 2017 Cator Vee <hi@catorv.com>. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "CLNetworkingManager.h"
#import "ApiRequestError.h"
#import "ApiRequestCacheError.h"
#import "MapObject.h"
#import "MapObject+Subscripts.h"

@class MapObject;


@interface ApiRequest : NSObject
/**
 * API接口请求
 *
 * 缓存策略说明:
 *  NSURLRequestReturnCacheDataElseLoad:
 *      返回有效的缓存数据，否则重新请求网络数据
 *  NSURLRequestReturnCacheDataDontLoad:
 *      只使用缓存数据，若无有效的缓存数据，请求失败。用于没有建立网络连接离线模式
 *  NSURLRequestUseProtocolCachePolicy: (默认缓存策略)
 *      忽略缓存，重新请求网络数据
 *  NSURLRequestReloadIgnoringCacheData:
 *      忽略缓存，重新请求网络数据
 *  NSURLRequestReloadIgnoringLocalCacheData:
 *      忽略缓存，重新请求网络数据
 *  NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
 *      忽略缓存，重新请求网络数据
 *  NSURLRequestReloadRevalidatingCacheData:
 *      返回有效的缓存数据，同时重新请求网络数据（注意：可能会调用两次success回调函数）
 *
 * @param urlString 接口地址
 * @param method 请求调用方法(HTTP method)
 * @param parameters 参数
 * @param cachePolicy 缓存策略
 * @param expired 过期时间（秒数 NSTimeInterval)
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)requestWithUrl:(NSString *)urlString method:(NetworkRequestType)method parameters:(id)parameters cachePolicy:(NSURLRequestCachePolicy)cachePolicy expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: GET方式
 *
 * @param urlString 接口地址
 * @param parameters 参数
 * @param cachePolicy 缓存策略
 * @param expired 过期时间（秒数 NSTimeInterval)
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)GET:(NSString *)urlString parameters:(id)parameters cachePolicy:(NSURLRequestCachePolicy)cachePolicy expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: GET方式
 * 缓存策略：NSURLRequestReturnCacheDataElseLoad
 *
 * @param urlString 接口地址
 * @param parameters 参数
 * @param expired 过期时间（秒数 NSTimeInterval)
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)GET:(NSString *)urlString parameters:(id)parameters expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: GET方式
 * 缓存策略：NSURLRequestUseProtocolCachePolicy
 *
 * @param urlString 接口地址
 * @param parameters 参数
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)GET:(NSString *)urlString parameters:(id)parameters success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: GET方式
 * 缓存策略：NSURLRequestUseProtocolCachePolicy
 *
 * @param urlString 接口地址
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)GET:(NSString *)urlString success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: POST方式
 *
 * @param urlString 接口地址
 * @param parameters 参数
 * @param cachePolicy 缓存策略
 * @param expired 过期时间（秒数 NSTimeInterval)
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)POST:(NSString *)urlString parameters:(id)parameters cachePolicy:(NSURLRequestCachePolicy)cachePolicy expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: POST方式
 * 缓存策略：NSURLRequestReturnCacheDataElseLoad
 *
 * @param urlString 接口地址
 * @param parameters 参数
 * @param expired 过期时间（秒数 NSTimeInterval)
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)POST:(NSString *)urlString parameters:(id)parameters expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: POST方式
 * 缓存策略：NSURLRequestUseProtocolCachePolicy
 *
 * @param urlString 接口地址
 * @param parameters 参数
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)POST:(NSString *)urlString parameters:(id)parameters success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: POST方式
 * 缓存策略：NSURLRequestUseProtocolCachePolicy
 *
 * @param urlString 接口地址
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)POST:(NSString *)urlString success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: PUT方式
 *
 * @param urlString 接口地址
 * @param parameters 参数
 * @param cachePolicy 缓存策略
 * @param expired 过期时间（秒数 NSTimeInterval)
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)PUT:(NSString *)urlString parameters:(id)parameters cachePolicy:(NSURLRequestCachePolicy)cachePolicy expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: PUT方式
 * 缓存策略：NSURLRequestReturnCacheDataElseLoad
 *
 * @param urlString 接口地址
 * @param parameters 参数
 * @param expired 过期时间（秒数 NSTimeInterval)
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)PUT:(NSString *)urlString parameters:(id)parameters expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: PUT方式
 * 缓存策略：NSURLRequestUseProtocolCachePolicy
 *
 * @param urlString 接口地址
 * @param parameters 参数
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)PUT:(NSString *)urlString parameters:(id)parameters success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: PUT方式
 * 缓存策略：NSURLRequestUseProtocolCachePolicy
 *
 * @param urlString 接口地址
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)PUT:(NSString *)urlString success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: DELETE方式
 *
 * @param urlString 接口地址
 * @param parameters 参数
 * @param cachePolicy 缓存策略
 * @param expired 过期时间（秒数 NSTimeInterval)
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)DELETE:(NSString *)urlString parameters:(id)parameters cachePolicy:(NSURLRequestCachePolicy)cachePolicy expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: DELETE方式
 * 缓存策略：NSURLRequestReturnCacheDataElseLoad
 *
 * @param urlString 接口地址
 * @param parameters 参数
 * @param expired 过期时间（秒数 NSTimeInterval)
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)DELETE:(NSString *)urlString parameters:(id)parameters expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: DELETE方式
 * 缓存策略：NSURLRequestUseProtocolCachePolicy
 *
 * @param urlString 接口地址
 * @param parameters 参数
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)DELETE:(NSString *)urlString parameters:(id)parameters success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

/**
 * API接口请求: DELETE方式
 * 缓存策略：NSURLRequestUseProtocolCachePolicy
 *
 * @param urlString 接口地址
 * @param success 调用成功回调函数
 * @param failure 调用失败回调函数
 */
+ (void)DELETE:(NSString *)urlString success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure;

@end