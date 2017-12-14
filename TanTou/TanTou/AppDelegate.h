//
//  AppDelegate.h
//  TanTou
//
//  Created by bailing on 2017/8/10.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) HomeViewController *homeVC;
@end

