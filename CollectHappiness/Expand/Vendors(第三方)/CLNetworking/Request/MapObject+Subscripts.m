//
// Created by Cator Vee on 15/09/2017.
// Copyright (c) 2017 Cator Vee <hi@catorv.com>. All rights reserved.
//

#import "MapObject+Subscripts.h"


@implementation MapObject (Subscripts)

- (MapObject *)objectForKeyedSubscript:(NSString *)key {
    return [self objectForKeyPath:key];
}

- (MapObject *)objectAtIndexedSubscript:(NSUInteger)idx {
    id object = self.object;
    if (idx >= 0 && object != nil) {
        if ([object isKindOfClass:NSArray.class]) {
            NSArray *ary = object;
            if (idx < ary.count) {
                return [MapObject object:ary[idx]];
            }
        }
    }
    return MapObject.emptyObject;
}

- (NSUInteger)count {
    id object = self.object;
    if (object != nil) {
        if ([object isKindOfClass:NSArray.class]) {
            return ((NSArray *) object).count;
        }
        if ([object isKindOfClass:NSDictionary.class]) {
            return ((NSDictionary *) object).count;
        }
    }
    return 0;
}

@end