//
//  ChristmasUserItem.h
//  TanTou
//
//  Created by StoneMan on 2017/11/16.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ChristmasUserItem : NSObject
#pragma mark - 属性
/**用户id*/
@property (strong, nonatomic) NSString *uid;
/**令牌*/
@property (strong, nonatomic) NSString *token;
/**openid*/
@property (strong, nonatomic) NSString *openid;
/**红包金钱*/
@property (strong, nonatomic) NSString *money;
/**今天的挑战次数*/
@property (strong, nonatomic) NSString *today_times;
/**分享次数*/
@property (strong, nonatomic) NSString *share_times;
/**分享后获得的挑战次数*/
@property (strong, nonatomic) NSString *challenge_times;
/**添加时间*/
@property (strong, nonatomic) NSString *add_time;
/**登陆类型*/
@property (strong, nonatomic) NSString *login_type;
/**今天时间*/
@property (strong, nonatomic) NSString *today_time;
/**用户名称*/
@property (strong, nonatomic) NSString *username;
/**用户头像*/
@property (strong, nonatomic) NSString *icon;
/**用户头像*/
@property (strong, nonatomic) NSString *last_money;
/**是否可以挑战*/
@property (strong, nonatomic) NSString *can_challenge;

#pragma mark - 方法
+ (instancetype)shareChristmasUserItem;
- (void)userItemFromUserDefaults;
- (void)saveUserItemToUserDefaults;

@end
