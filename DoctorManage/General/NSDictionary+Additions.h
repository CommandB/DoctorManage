//
//  NSDictionary+Additions.h
//  games
//
//  Created by xuesai on 12-10-15.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)
- (BOOL)hasKey:(NSString*)key;
- (NSInteger)intValueForKey:(NSString*)key;
- (NSString *)stringValueForKey:(NSString*)key;
- (BOOL)boolValueForKey:(NSString*)key;
@end