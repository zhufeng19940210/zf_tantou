//
//  NSString+ZXSExtension.h
//  TanTou
//
//  Created by StoneMan on 2017/11/7.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZXSExtension)

/**
 * 手机号码格式验证
 */
+ (BOOL)zxs_isTelphoneNumber:(NSString *)telNum;

/**
 利用NSCharacterSet的stringByTrimmingCharactersInSet方法检测字符串是否为纯数字字符串
 */
+ (BOOL)zxs_isPureNumberStringByCharacterSetWithCheckedNumberString:(NSString *)checkedNumberString;

/**
 利用NSScanner类来判断检测字符串是否为纯数字字符串
 NSScanner是一个类，用于在字符串中扫描指定的字符
 */
+ (BOOL)zxs_isPureNumberStringByScannerWithCheckedNumberString:(NSString *)checkedNumberString;

/**
 利用正则表达式来判断检测字符串是否为纯数字字符串
 */
+ (BOOL)zxs_isPureNumberStringByRegularWithCheckedNumberString:(NSString *)checkedNumberString;
@end
