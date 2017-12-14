//
//  ZFCustomAlterView.h
//  BL6600
//
//  Created by bailing on 2017/9/8.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZFCustomAlterViewDelegate <NSObject>
-(void)customAlterViewHidden;
@end
@interface ZFCustomAlterView : UIView
@property (nonatomic,weak)id <ZFCustomAlterViewDelegate>delegate;
-(void)showShareViewAddView:(UIView *)myView;
-(void)hihhdenView;
@end
