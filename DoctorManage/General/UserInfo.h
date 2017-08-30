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

//
//@property (nonatomic, strong) NSString *userId;
//@property (nonatomic, strong) NSString *userName;
//@property (nonatomic, strong) NSString *nickName;
//@property (nonatomic, strong) NSString *loginType;
//@property (nonatomic, strong) NSString *imToken;
//@property (nonatomic, strong) NSString *expireTime;
//@property (nonatomic, strong) NSString *accessToken;
//
//@property (nonatomic, assign) NSInteger age;
//@property (nonatomic, assign) NSInteger sex;
//@property (nonatomic, strong) NSString *picurl;
//@property (nonatomic, assign) NSInteger star;

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *companyname;
@property (nonatomic, strong) NSString *companyid;
@property (nonatomic, strong) NSString *userkey;

+ (instancetype)instance;
+ (void)archiverUserInfo;
- (void)saveUserInfo:(NSDictionary*)aDict;
- (void)logout;

@end

