//
// Created by Cator Vee on 14/09/2017.
// Copyright (c) 2017 Cator Vee <hi@catorv.com>. All rights reserved.
//

#import "MapObject.h"


@implementation MapObject {

}

- (id)copyWithZone:(nullable NSZone *)zone {
    MapObject *newObject = [[MapObject allocWithZone:zone] init];
    newObject.object = self.object;
    return newObject;
}

- (instancetype)initWithObject:(id)object {
    self = [super init];
    if (self) {
        _object = object;
    }
    return self;
}

+ (instancetype)object:(id)object {
    return [[self alloc] initWithObject:object];
}

+ (instancetype)emptyObject {
    static MapObject *emptyMapObject;
    if (emptyMapObject == nil) {
        emptyMapObject = [MapObject new];
    }
    return emptyMapObject;
}

- (BOOL)isEmpty {
    return _object == nil;
}

- (instancetype)objectForKeyPath:(NSString *)keyPath {
    if (_object == nil || keyPath == nil) {
        return MapObject.emptyObject;
    }
    MapObject *value = [_object valueForKeyPath:keyPath];
    return [[MapObject alloc] initWithObject:value];
}

- (nullable id)valueForKeyPath:(NSString *)keyPath {
    if (_object != nil) {
        return [_object valueForKeyPath:keyPath];
    }
    return nil;
}

- (NSArray<MapObject *> *)objects {
    NSArray *ary = [self arrayValue];
    NSMutableArray<MapObject *> *result = [NSMutableArray arrayWithCapacity:ary.count];
    for (id item in ary) {
        [result addObject:[MapObject object:item]];
    }
    return result;
}

- (NSString *)description {
    if (_object == nil) {
        return @"nil";
    }
    return [_object description];
}

- (NSInteger)integerValue {
    if (_object != nil) {
        if ([_object isKindOfClass:NSNumber.class] || [_object isKindOfClass:NSString.class]) {
            return [_object integerValue];
        }
        return [_object integerValue];
    }
    return 0;
}

- (long)longValue {
    if (_object != nil) {
        if ([_object isKindOfClass:NSNumber.class] || [_object isKindOfClass:NSString.class]) {
            return [_object longValue];
        }
        return [_object longValue];
    }
    return 0;
}

- (float)floatValue {
    if (_object != nil) {
        if ([_object isKindOfClass:NSNumber.class] || [_object isKindOfClass:NSString.class]) {
            return [_object floatValue];
        }
        return [_object floatValue];
    }
    return 0.0f;
}

- (double)doubleValue {
    if (_object != nil) {
        if ([_object isKindOfClass:NSNumber.class] || [_object isKindOfClass:NSString.class]) {
            return [_object doubleValue];
        }
        return [_object doubleValue];
    }
    return 0.0;
}

- (BOOL)boolValue {
    if (_object != nil) {
        if ([_object isKindOfClass:NSNumber.class] || [_object isKindOfClass:NSString.class]) {
            return [_object boolValue];
        }
        return [_object boolValue];
    }
    return false;
}

- (NSString *)string {
    if (_object != nil) {
        if ([_object isKindOfClass:NSString.class]) {
            return _object;
        }
        return [_object description];
    }
    return nil;
}

- (NSString *)stringValue {
    return _object == nil ? @"": [self string];
}

- (NSArray *)array {
    if ([_object isKindOfClass:NSArray.class]) {
        return _object;
    }
    return nil;
}

- (NSArray *)arrayValue {
    if ([_object isKindOfClass:NSArray.class]) {
        return _object;
    }
    return [NSArray array];
}

- (NSDictionary *)dictionary {
    if ([_object isKindOfClass:NSDictionary.class]) {
        return _object;
    }
    return nil;
}

- (NSDictionary *)dictionaryValue {
    if ([_object isKindOfClass:NSDictionary.class]) {
        return _object;
    }
    return [NSDictionary dictionary];
}

- (NSURL *)url {
    NSString *str = self.string;
    if (str != nil && str.length > 0) {
        return [NSURL URLWithString:str];
    }
    return nil;
}

- (MapObject *)jsonObject {
    if ([_object isKindOfClass:NSString.class]) {
        NSString *str = _object;
        if (str.length > 0) {
            return [MapObject object:JSON2OBJ(str)];
        }
        return MapObject.emptyObject;
    }
    return self;
}

- (NSString *)jsonString {
    if (_object != nil) {
        return OBJ2JSON(_object);
    }
    return @"";
}

@end