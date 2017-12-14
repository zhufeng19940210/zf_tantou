//
//  NSDate+ZXSExtension.m
//  TanTou
//
//  Created by StoneMan on 2017/11/15.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import "NSDate+ZXSExtension.h"

@implementation NSDate (ZXSExtension)

/**
 比较两个时间大小
 1：otherDateString比dateString大
 -1：otherDateString比dateString小
 0：otherDateString=dateString
 */
+ (NSInteger)zxs_compareDateString:(NSString*)dateString otherDateString:(NSString*)otherDateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSDate *otherdate = [dateFormatter dateFromString:otherDateString];
    
    NSInteger backInteger;
    NSComparisonResult result = [date compare:otherdate];
    switch (result){
            //otherDateString比dateString大
        case NSOrderedAscending: backInteger = 1; break;
            //otherDateString比dateString小
        case NSOrderedDescending: backInteger = -1; break;
            //otherDateString=dateString
        case NSOrderedSame: backInteger = 0; break;
        default: NSLog(@"erorr dates %@, %@", date, otherdate); break;
    }
    return backInteger;
}

@end
