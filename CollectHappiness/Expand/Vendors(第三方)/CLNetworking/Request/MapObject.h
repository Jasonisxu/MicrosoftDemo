//
// Created by Cator Vee on 14/09/2017.
// Copyright (c) 2017 Cator Vee <hi@catorv.com>. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapObject : NSObject <NSCopying>

@property (nonatomic, strong) id object;

- (instancetype)initWithObject:(id)object;
+ (instancetype)object:(id)object;
+ (instancetype)emptyObject;
- (BOOL)isEmpty;

- (instancetype)objectForKeyPath:(NSString *)keyPath;
- (NSArray<MapObject *> *)objects;

- (NSInteger)integerValue;
- (long)longValue;
- (float)floatValue;
- (double)doubleValue;
- (BOOL)boolValue;

- (NSString *)string;
- (NSString *)stringValue;

- (NSArray *)array;
- (NSArray *)arrayValue;
- (NSDictionary *)dictionary;
- (NSDictionary *)dictionaryValue;

- (NSURL *)url;

/** 解析JSON字符串为MapObject对象 */
- (MapObject *)jsonObject;
/** 序列化MapObject对象为JSON字符串 */
- (NSString *)jsonString;

@end