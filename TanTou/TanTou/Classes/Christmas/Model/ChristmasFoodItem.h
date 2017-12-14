//
//  ChristmasFoodItem.h
//  TanTou
//
//  Created by StoneMan on 2017/11/17.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChristmasFoodItem : NSObject

/**question_id*/
@property (strong, nonatomic) NSString *question_id;
/**问题*/
@property (strong, nonatomic) NSString *question;
/**选项*/
@property (strong, nonatomic) NSArray *choice;
/**图片地址*/
@property (strong, nonatomic) NSString *img_url;

@end
