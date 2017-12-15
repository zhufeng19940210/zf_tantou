//
//  ShareView.h
//  TYAlertControllerDemo
//
//  Created by tanyang on 15/10/26.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShareViewDelegate <NSObject>
-(void)clickMyShareButtonWithTag:(int)tag;
    @end
@interface ShareView : UIView
@property (nonatomic,weak) id <ShareViewDelegate> delegate;
@end
