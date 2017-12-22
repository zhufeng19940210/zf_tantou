//
//  AppDelegate.h
//  TanTou
//
//  Created by bailing on 2017/8/10.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
//定义一个枚举来判断这个东西的了
typedef enum : NSUInteger {
    LocolVersionToAppStoreVersionEqual = 0,//本地等于appStore版本号
    LocolVersionToAppStoreVersionLarge = 1,//本地大于appStore版本号
    LocolVersionToAppStoreVersionSmall = 2,//本地小于appStore版本号
} CompareVersionType;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
/**
 *  appStore版本号
 */
@property (nonatomic, copy) NSString *appStoreVersion;
/**
 *  本地版本号
 */
@property (nonatomic, copy) NSString *localVersion;
/**
 *  appStore下载链接
 */
@property (nonatomic, copy) NSString *urlStr;

/**
 *  本地版本号与appStore版本号的大小关系
 */
@property (nonatomic, assign) CompareVersionType type;
@end


