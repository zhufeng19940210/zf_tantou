//
//  YJTComposeView.h
//  WeiBoProject
//
//  Created by yejingtao on 16/6/2.
//  Copyright © 2016年 yejingtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJTComposeView : UITextView

@property (strong, nonatomic) NSString *placeholder;
@property (strong, nonatomic) UIColor *placeholderColor;

- (void)textChanged:(NSNotification*)notification;

@end
