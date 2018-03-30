//
//  ChristmasUserItem.m
//  TanTou
//
//  Created by StoneMan on 2017/11/16.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import "ChristmasUserItem.h"

@implementation ChristmasUserItem

// 创建静态对象 防止外部访问
static ChristmasUserItem *_instance;

#pragma mark - 系统方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    //方式一：互斥锁方式
    //    @synchronized (self) {
    //        // 为了防止多线程同时访问对象，造成多次分配内存空间，所以要加上线程锁
    //        if (_instance == nil) {
    //            _instance = [super allocWithZone:zone];
    //        }
    //        return _instance;
    //    }
    
    //方式二：GCD方式创建单例，使用一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}
// 为了使实例易于外界访问 我们一般提供一个类方法，类方法命名规范 share类名|default类名|类名
+ (instancetype)shareChristmasUserItem {
    //return _instance;
    // 最好用self 用ChristmasUserItem他的子类调用时会出现错误
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}
#pragma mark - 数据存储和获取
- (void)userItemFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.uid = [userDefaults objectForKey:@"uid"];
    self.token = [userDefaults objectForKey:@"token"];
    self.openid = [userDefaults objectForKey:@"openid"];
    self.money = [userDefaults objectForKey:@"money"];
    self.today_times = [userDefaults objectForKey:@"today_times"];
    self.share_times = [userDefaults objectForKey:@"share_times"];
    self.challenge_times = [userDefaults objectForKey:@"challenge_times"];
    self.add_time = [userDefaults objectForKey:@"add_time"];
    self.login_type = [userDefaults objectForKey:@"login_type"];
    self.today_time = [userDefaults objectForKey:@"today_time"];
    self.username = [userDefaults objectForKey:@"username"];
    self.icon = [userDefaults objectForKey:@"icon"];
    self.last_money = [userDefaults objectForKey:@"last_money"];
    self.can_challenge = [userDefaults objectForKey:@"can_challenge"];
}
- (void)saveUserItemToUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:self.uid forKey:@"uid"];
    [userDefaults setValue:self.token forKey:@"token"];
    [userDefaults setValue:self.openid forKey:@"openid"];
    [userDefaults setValue:self.money forKey:@"money"];
    [userDefaults setValue:self.today_times forKey:@"today_times"];
    [userDefaults setValue:self.share_times forKey:@"share_times"];
    [userDefaults setValue:self.challenge_times forKey:@"challenge_times"];
    [userDefaults setValue:self.add_time forKey:@"add_time"];
    [userDefaults setValue:self.login_type forKey:@"login_type"];
    [userDefaults setValue:self.today_time forKey:@"today_time"];
    [userDefaults setValue:self.username forKey:@"username"];
    [userDefaults setValue:self.icon forKey:@"icon"];
    [userDefaults setValue:self.last_money forKey:@"last_money"];
    [userDefaults setValue:self.can_challenge forKey:@"can_challenge"];
    [userDefaults synchronize];
}
@end
