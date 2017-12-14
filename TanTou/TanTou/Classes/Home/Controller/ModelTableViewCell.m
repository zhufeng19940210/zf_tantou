//
//  ModelTableViewCell.m
//  TanTou
//
//  Created by Sharon on 2017/8/30.
//  Copyright © 2017年 bailing. All rights reserved.
//  食物展示的cell

#import "ModelTableViewCell.h"

@implementation ModelTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {

        self.selectionStyle = 0;
        
        self.imagetitle=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 10, 30)];
        self.imagetitle.image=[UIImage imageNamed:@"xiaolv"];
        [self addSubview:_imagetitle];
        
        self.titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 15, 60, 30)];
        self.titlelabel.text=@"牛肉";
        [self addSubview:_titlelabel];
        
        self.openimage=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-60, 15, 20, 30)];
        self.openimage.image=[UIImage imageNamed:@"you"];
        [self addSubview:_openimage];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
