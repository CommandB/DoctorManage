//
//  UserInfo.h
//  LL
//
//  Created by sai on 13-12-13.
//
//

#import <Foundation/Foundation.h>
#import "NSDictionary+Additions.h"

@interface UserInfo : NSObject<NSCoding>


@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *companyname;
@property (nonatomic, strong) NSString *companyid;
@property (nonatomic, strong) NSString *userkey;

+ (instancetype)instance;
+ (void)archiverUserInfo;
- (void)saveUserInfo:(NSDictionary*)aDict;
- (void)logout;

- (void)saveOfficeInfo:(NSData*)jsonData;
- (id)getOfficeInfo;
@end

