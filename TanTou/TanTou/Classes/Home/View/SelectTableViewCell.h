//
//  SelectTableViewCell.h
//  TanTou
//
//  Created by zhufeng on 2017/8/30.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *kaluliLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@end
