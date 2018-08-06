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
#define kJson_Path [kDocumentDirectory stringByAppendingPathComponent:@"JsonFile.json"]

#define kToken          @"token"
#define kCompanyname    @"companyname"
#define kCompanyid      @"companyid"

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
    [self removeJsonFile];
}

- (void)reset:(NSDictionary*)aDict {
    _token = [aDict stringValueForKey:kToken];
    _companyname = [aDict stringValueForKey:kCompanyname];
    _companyid = [aDict stringValueForKey:kCompanyid];
    _userkey = [aDict stringValueForKey:@"userkey"];
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_token forKey:kToken];
    [encoder encodeObject:_companyname forKey:kCompanyname];
    [encoder encodeObject:_companyid forKey:kCompanyid];
    [encoder encodeObject:_userkey forKey:@"userkey"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _token = [decoder decodeObjectForKey:kToken];
        _companyname = [decoder decodeObjectForKey:kCompanyname];
        _companyid = [decoder decodeObjectForKey:kCompanyid];
        _userkey = [decoder decodeObjectForKey:@"userkey"];
    }
    return self;
}


- (void)saveOfficeInfo:(NSData*)jsonData{
    NSLog(@"%@",[jsonData writeToFile:kJson_Path atomically:YES] ? @"Succeed":@"Failed");
}

- (void)removeJsonFile{
    [[NSFileManager defaultManager] removeItemAtPath:kJson_Path error:nil];
}

- (id)getOfficeInfo
{
    NSData *data = [NSData dataWithContentsOfFile:kJson_Path];
    id JsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                      error:nil];
    return JsonObject;
}
@end













