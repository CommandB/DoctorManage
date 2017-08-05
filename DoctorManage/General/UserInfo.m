//
//  UserInfo.m
//  LL
//
//  Created by sai on 13-12-13.
//
//

#import "UserInfo.h"

//目录相关
#define kDocumentDirectory ([NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,\
NSUserDomainMask,YES) objectAtIndex:0])
#define kUserInfoFilePath [kDocumentDirectory stringByAppendingPathComponent:@"userInfo"]

#define kToken          @"token"
#define kCompanyname    @"companyname"
#define kCompanyid      @"companyid"

//#define kAge @"age"
//#define kSex @"sex"
//#define kIsVip @"is_vip"
//#define kPicurl @"picurl"
//#define kStar @"star"
//#define kBirthday @"brithday"
//#define kPhone @"phone"

@interface UserInfo ()
@end

@implementation UserInfo

+ (void)archiverUserInfo {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:[UserInfo instance] forKey:@"userInfo"];
    [archiver finishEncoding];
    [data writeToFile:kUserInfoFilePath atomically:YES];
}

+ (instancetype)instance {
    static UserInfo *userInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:kUserInfoFilePath]) {
            NSData *data = [[NSMutableData alloc]
                            initWithContentsOfFile:kUserInfoFilePath];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                             initForReadingWithData:data];
            userInfo = [unarchiver decodeObjectForKey:@"userInfo"];
            [unarchiver finishDecoding];
        } else {
            userInfo = [[UserInfo alloc] init];
        }
    });
    return userInfo;
}

- (void)saveUserInfo:(NSDictionary*)aDict {
    [[UserInfo instance] reset:aDict];
    [UserInfo archiverUserInfo];
}

- (void)logout {
    [self saveUserInfo:nil];
}

- (void)reset:(NSDictionary*)aDict {
    _token = [aDict stringValueForKey:kToken];
    _companyname = [aDict stringValueForKey:kCompanyname];
    _companyid = [aDict stringValueForKey:kCompanyid];
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_token forKey:kToken];
    [encoder encodeObject:_companyname forKey:kCompanyname];
    [encoder encodeObject:_companyid forKey:kCompanyid];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _token = [decoder decodeObjectForKey:kToken];
        _companyname = [decoder decodeObjectForKey:kCompanyname];
        _companyid = [decoder decodeObjectForKey:kCompanyid];
    }
    return self;
}

@end













