//
//  ModelTableViewCell.h
//  TanTou
//
//  Created by Sharon on 2017/8/30.
//  Copyright © 2017年 bailing. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface ModelTableViewCell : UITableViewCell
@property(nonatomic,assign) BOOL isOpen;
@property(nonatomic,strong) UIImageView*imagetitle;
@property(nonatomic,strong) UILabel*titlelabel;
@property(nonatomic,strong) UIImageView*openimage;
@end
