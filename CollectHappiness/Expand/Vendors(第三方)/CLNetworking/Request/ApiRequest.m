//
// Created by Cator Vee on 13/09/2017.
// Copyright (c) 2017 Cator Vee <hi@catorv.com>. All rights reserved.
//

#import "ApiRequest.h"

@implementation ApiRequest

+ (void)requestWithUrl:(NSString *)urlString method:(NetworkRequestType)method parameters:(id)parameters cachePolicy:(NSURLRequestCachePolicy)cachePolicy expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    
    NSString *key = [self cacheKey:urlString parameters:parameters method:method];
#ifdef DEBUG
    NSArray *stack = [NSThread callStackSymbols];
    NSString *trace = @"";
    for (NSString *record in stack) {
        if ([record rangeOfString:@"ApiRequest"].location == NSNotFound) {
            NSString *pattern = @"(\\+|\\-)\\[.*?\\]";
            NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
            NSTextCheckingResult *result = [regex firstMatchInString:record options:0 range:NSMakeRange(0, record.length)];
            trace = [record substringWithRange:result.range];
            break;
        }
    }
    NSString *shortKey = [key substringToIndex:4];
    switch (method) {
            case NetworkRequestTypeGET:
            LOG_I("API#%@ GET %@ %@  %@", shortKey, urlString, parameters == nil ? @"" : OBJ2JSON(parameters), trace);
            break;
            case NetworkRequestTypePOST:
            LOG_I("API#%@ POST %@ %@  %@", shortKey, urlString, parameters == nil ? @"" : OBJ2JSON(parameters), trace);
            break;
            case NetworkRequestTypePUT:
            LOG_I("API#%@ PUT %@ %@  %@", shortKey, urlString, parameters == nil ? @"" : OBJ2JSON(parameters), trace);
            break;
            case NetworkRequestTypeDELETE:
            LOG_I("API#%@ DELETE %@ %@  %@", shortKey, urlString, parameters == nil ? @"" : OBJ2JSON(parameters), trace);
            break;
    }
#endif
    
    id cacheData = [self cacheDataForKey:key withCachePolicy:cachePolicy];
    BOOL hasCache = (cacheData != nil);
    // 判断网址是否加载过，如果没有加载过 在执行网络请求成功时，将请求时间和网址存入UserDefaults，value为时间date、Key为网址
    if (hasCache) {
        LOG_D("API#%@ %@  %@", shortKey, OBJ2JSON(cacheData), trace);
        if (success != nil) {
            success([MapObject object:cacheData[@"result"]], cacheData);
        }
        if (cachePolicy != NSURLRequestReloadRevalidatingCacheData) {
            return;
        }
    }
    
    if (cachePolicy == NSURLRequestReturnCacheDataDontLoad) {
        if (failure != nil) {
            failure([[ApiRequestCacheError alloc] initWithDomain:@"获取缓存数据失败" code:1 userInfo:nil]);
        }
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

//    if (loginUserModel) {
//        [manager.requestSerializer setValue:loginUserModel.token forHTTPHeaderField:@"token"];
//    }
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    //设置超时时间
    manager.requestSerializer.timeoutInterval = 10;
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    void (^successHandler)(NSURLSessionDataTask *, id)=^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        if (error != nil) {
            LOG_D("API#%@ %@  %@", shortKey, [error localizedDescription], trace);
            if (failure != nil) {
                failure(error);
            }
            return;
        }
        int code = [RESPONSE_CODE intValue];
        if (code == 1) {
            LOG_D("API#%@ \n%@  \n%@", shortKey, data, trace);
            
            if (success != nil) {
                success([MapObject object:RESPONSE_RESULT], data);
            }
            if (expired >= 0.0) {
                NSTimeInterval _expired = (expired == 0.0 ? 0.0 : expired + [NSDate timeIntervalSinceReferenceDate]);
                [self saveCacheData:data whitCachePolicy:cachePolicy expired:_expired forKey:key];
            }
        } else {
            LOG_W("API#%@ [code=%@] %@  %@", shortKey, RESPONSE_CODE, RESPONSE_MSG, trace);
            
    
//            if (code == 10002 || code == 10006 || code == 00000001 || code == 00000010) {
//                loginInfo = nil;
//                [NSKeyedArchiver archiveRootObject:loginInfo toFile:[HelperUtil fileByDocumentPath:LoginInfoPath]];
//                [[NSNotificationCenter defaultCenter] postNotificationName:LoginStateNotification object:@"login"];
//            
//                return;
//            }
//            switch (code) {
//                    case 10002: // 用户已停用
//                    // TODO: 重新登录
//                    return;
//                    case 10006: // 登录已过期或用户没有登录
//                    // TODO: 重新登录
//                    return;
//                    case 00000001: // 您还未登录或者登录已超时,请重新登录
//                    // TODO: 重新登录
//                    return;
//                    case 00000010: // 这个账号在别的设备登陆
//                    // TODO: 重新登录
//                    return;
//                default:
//                    break;
//            }
            
            if (failure != nil) {
                failure([[ApiRequestError alloc] initWithDomain:RESPONSE_MSG
                                                           code:[RESPONSE_CODE integerValue]
                                                       userInfo:nil]);
            }
        }
    };
    void (^failureHandler)(NSURLSessionDataTask *, NSError *)=^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        LOG_E("API#%@ %@  %@", shortKey, [error localizedDescription], trace);
        if (cachePolicy == NSURLRequestReloadRevalidatingCacheData && hasCache) {
            return;
        }
        if (failure != nil) {
            failure(error);
        }
    };
    
    switch (method) {
            case NetworkRequestTypeGET:
            [manager GET:urlString parameters:parameters progress:nil success:successHandler failure:failureHandler];
            break;
            case NetworkRequestTypePOST:
            [manager POST:urlString parameters:parameters progress:nil success:successHandler failure:failureHandler];
            break;
            case NetworkRequestTypePUT:
            [manager PUT:urlString parameters:parameters success:successHandler failure:failureHandler];
            break;
            case NetworkRequestTypeDELETE:
            manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
            [manager DELETE:urlString parameters:parameters success:successHandler failure:failureHandler];
            break;
    }
}

// =========================================

+ (void)GET:(NSString *)urlString parameters:(id)parameters cachePolicy:(NSURLRequestCachePolicy)cachePolicy expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypeGET parameters:parameters cachePolicy:cachePolicy expired:expired success:success failure:failure];
}

+ (void)GET:(NSString *)urlString parameters:(id)parameters expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypeGET parameters:parameters cachePolicy:NSURLRequestReturnCacheDataElseLoad expired:expired success:success failure:failure];
}

+ (void)GET:(NSString *)urlString parameters:(id)parameters success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypeGET parameters:parameters cachePolicy:NSURLRequestUseProtocolCachePolicy expired:0 success:success failure:failure];
}

+ (void)GET:(NSString *)urlString success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypeGET parameters:nil cachePolicy:NSURLRequestUseProtocolCachePolicy expired:0 success:success failure:failure];
}

// =========================================

+ (void)POST:(NSString *)urlString parameters:(id)parameters cachePolicy:(NSURLRequestCachePolicy)cachePolicy expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypePOST parameters:parameters cachePolicy:cachePolicy expired:expired success:success failure:failure];
}

+ (void)POST:(NSString *)urlString parameters:(id)parameters expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypePOST parameters:parameters cachePolicy:NSURLRequestReturnCacheDataElseLoad expired:expired success:success failure:failure];
}

+ (void)POST:(NSString *)urlString parameters:(id)parameters success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypePOST parameters:parameters cachePolicy:NSURLRequestUseProtocolCachePolicy expired:0 success:success failure:failure];
}

+ (void)POST:(NSString *)urlString success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypePOST parameters:nil cachePolicy:NSURLRequestUseProtocolCachePolicy expired:0 success:success failure:failure];
}

// =========================================

+ (void)PUT:(NSString *)urlString parameters:(id)parameters cachePolicy:(NSURLRequestCachePolicy)cachePolicy expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypePUT parameters:parameters cachePolicy:cachePolicy expired:expired success:success failure:failure];
}

+ (void)PUT:(NSString *)urlString parameters:(id)parameters expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypePUT parameters:parameters cachePolicy:NSURLRequestReturnCacheDataElseLoad expired:expired success:success failure:failure];
}

+ (void)PUT:(NSString *)urlString parameters:(id)parameters success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypePUT parameters:parameters cachePolicy:NSURLRequestUseProtocolCachePolicy expired:0 success:success failure:failure];
}

+ (void)PUT:(NSString *)urlString success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypePUT parameters:nil cachePolicy:NSURLRequestUseProtocolCachePolicy expired:0 success:success failure:failure];
}

// =========================================

+ (void)DELETE:(NSString *)urlString parameters:(id)parameters cachePolicy:(NSURLRequestCachePolicy)cachePolicy expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypeDELETE parameters:parameters cachePolicy:cachePolicy expired:expired success:success failure:failure];
}

+ (void)DELETE:(NSString *)urlString parameters:(id)parameters expired:(NSTimeInterval)expired success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypeDELETE parameters:parameters cachePolicy:NSURLRequestReturnCacheDataElseLoad expired:expired success:success failure:failure];
}

+ (void)DELETE:(NSString *)urlString parameters:(id)parameters success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypeDELETE parameters:parameters cachePolicy:NSURLRequestUseProtocolCachePolicy expired:0 success:success failure:failure];
}

+ (void)DELETE:(NSString *)urlString success:(void (^)(MapObject *result, id data))success failure:(void(^)(NSError *_Nonnull error))failure {
    [self requestWithUrl:urlString method:NetworkRequestTypeDELETE parameters:nil cachePolicy:NSURLRequestUseProtocolCachePolicy expired:0 success:success failure:failure];
}

// =========================================

+ (NSString *)cacheKey:(NSString *)urlString parameters:(id)parameters method:(NetworkRequestType)method {
    NSString *absoluteURL = [NSString generateGETAbsoluteURL:urlString params:parameters];
    NSString *key = [NSString networkingUrlString_md5:absoluteURL];
    return [NSString stringWithFormat:@"%d%@", method, key];
}

+ (id)cacheDataForKey:(NSString *)key withCachePolicy:(NSURLRequestCachePolicy)cachePolicy {
    switch (cachePolicy) {
            case NSURLRequestReturnCacheDataElseLoad:
            case NSURLRequestReturnCacheDataDontLoad:
            case NSURLRequestReloadRevalidatingCacheData:
            return [self cacheDataForKey:key];
            //        case NSURLRequestUseProtocolCachePolicy:
            //        case NSURLRequestReloadIgnoringCacheData: // NSURLRequestReloadIgnoringLocalCacheData
            //        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            //            return nil;
        default:
            return nil;
    }
}

+ (id)cacheDataForKey:(NSString *)key {
    NSString *cacheFile = [self cacheFileForKey:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cacheFile]) {
        NSData *data = [NSData dataWithContentsOfFile:cacheFile];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
        if (dict != nil && dict[@"data"] != nil && dict[@"expired"] != nil) {
            NSTimeInterval expired = [dict[@"expired"] doubleValue];
            if (expired == 0 || expired < [NSDate timeIntervalSinceReferenceDate]) {
                LOG_I("API#%@ 读取缓存: %@", [key substringToIndex:4], cacheFile);
                return dict[@"data"];
            }
        }
    }
    return nil;
}

+ (void)saveCacheData:(id)data whitCachePolicy:(NSURLRequestCachePolicy)cachePolicy expired:(NSTimeInterval)expired forKey:(NSString *)key {
    switch (cachePolicy) {
            case NSURLRequestReturnCacheDataElseLoad:
            case NSURLRequestReturnCacheDataDontLoad:
            case NSURLRequestReloadRevalidatingCacheData:
            break;
            //        case NSURLRequestUseProtocolCachePolicy:
            //        case NSURLRequestReloadIgnoringCacheData: // NSURLRequestReloadIgnoringLocalCacheData
            //        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            //            return;
        default:
            return;
    }
    
    NSDictionary *dict = @{ @"expired": @(expired),  @"data": data };
    NSData *cacheData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *cacheFile = [self cacheFileForKey:key];
    [cacheData writeToFile:cacheFile atomically:YES];
    LOG_I("API#%@ 写入缓存: %@", [key substringToIndex:4], cacheFile);
}

+ (NSString *)cacheFileForKey:(NSString *)key {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDir = [paths[0] stringByAppendingPathComponent:@"_api_request"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cacheDir]) {
        [fileManager createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return  [cacheDir stringByAppendingPathComponent:key];
}

@end


