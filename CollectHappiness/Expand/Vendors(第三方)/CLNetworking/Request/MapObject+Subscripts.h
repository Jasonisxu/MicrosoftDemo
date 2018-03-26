//
// Created by Cator Vee on 15/09/2017.
// Copyright (c) 2017 Cator Vee <hi@catorv.com>. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapObject.h"

@interface MapObject (Subscripts)

- (MapObject *)objectForKeyedSubscript:(NSString *)key;

- (MapObject *)objectAtIndexedSubscript:(NSUInteger)idx;

- (NSUInteger)count;

@end