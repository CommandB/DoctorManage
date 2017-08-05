//
//  NSDictionary+Additions.m
//  games
//
//  Created by xuesai on 12-10-15.
//
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

- (BOOL)hasKey:(NSString*)key {
    for (NSString* k in [self allKeys]) {
        if ([k isEqualToString:key]) {
            return YES;
        }
    }
    return NO;  
}

- (NSInteger)intValueForKey:(NSString*)key {
    NSInteger result = 0;
    id value = [self objectForKey:key];
    if (value != nil) {
        if ([value isKindOfClass:[NSString class]]) {
            result = [(NSString *)value integerValue];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            result = [(NSNumber *)value integerValue];
        }
    }
    return result;
}

- (NSString *)stringValueForKey:(NSString*)key {
    NSString *result = nil;
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        result = value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        result = [(NSNumber *)value stringValue];
    }
    return result;
}

- (BOOL)boolValueForKey:(NSString*)key {
    NSInteger intValue = 0;
    id value = [self objectForKey:key];
    if (value != nil) {
        if ([value isKindOfClass:[NSString class]]) {
            intValue = [(NSString *)value integerValue];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            intValue = [(NSNumber *)value integerValue];
        }
    }
    return intValue == 1;
}
@end
