//
//  NSDate+ZXSExtension.h
//  TanTou
//
//  Created by StoneMan on 2017/11/15.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZXSExtension)

/**
 比较两个时间大小
 1：otherDateString比dateString大
 -1：otherDateString比dateString小
 0：otherDateString=dateString
 */
+ (NSInteger)zxs_compareDateString:(NSString*)dateString otherDateString:(NSString*)otherDateString;

@end
