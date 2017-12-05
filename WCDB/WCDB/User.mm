//
//  User.m
//  WCDB
//
//  Created by 张俊博 on 2017/12/5.
//

#import "User.h"
#import <WCDB/WCDB.h>
#import <UIKit/UIKit.h>

@interface User (WCTTableCoding)

#pragma mark - 声明需要绑定到数据库表的字段
WCDB_PROPERTY(userName)

@end

@implementation User (WCTTableCoding)

#pragma mark - 定义绑定到数据库表的类
WCDB_IMPLEMENTATION(User)

#pragma mark - 定义需要绑定到数据库表的字段
WCDB_SYNTHESIZE(User, userName)

#pragma mark - 设置主键
WCDB_PRIMARY(User, userName)

#pragma mark - 设置索引
WCDB_INDEX(User, "_index", userName)

@end

@implementation User

static User *instance = nil;
+ (User *)defaultUser {
    if (instance) {
        return instance;
    }
    @synchronized (self) {
        if (instance == nil) {
            instance = [[User alloc] init];
            //            [instance creatUserDB];
        }
    }
    return instance;
}

+ (void)load {
    //load中直接调用会crash
    [self testCreate];
    
    //ApplicationDidFinishLaunching 后调用没有问题
//    [[NSNotificationCenter defaultCenter] addObserver:[User defaultUser] selector:@selector(applicationDidFinishLaunchingNotification:) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

- (void)applicationDidFinishLaunchingNotification:(NSNotification *)noti {
    [User testCreate];
}

+ (void)testCreate {
    
    [WCTStatistics SetGlobalSQLTrace:^(NSString *sql) {
        NSLog(@"SQL: %@", sql);
    }];
    [WCTStatistics SetGlobalErrorReport:^(WCTError *error) {
        NSLog(@"SQL: %@", error);
    }];
    
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    docsdir = [docsdir stringByAppendingPathComponent:@"user.db"];
    WCTDatabase *database = [[WCTDatabase alloc] initWithPath:docsdir];
    BOOL res = [database createTableAndIndexesOfName:@"user" withClass:self.class];
    
    NSLog(@"");
}

@end
