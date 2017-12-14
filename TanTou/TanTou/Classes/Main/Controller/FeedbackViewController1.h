//
//  FeedbackViewController1.h
//  The  probe
//
//  Created by Sharon on 2017/8/7.
//  Copyright © 2017年 daodian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTMobBannerView.h" //导入GDTMobBannerView.h头文件
@interface FeedbackViewController1 : UIViewController<GDTMobBannerViewDelegate>
{
    GDTMobBannerView *_bannerView;//声明一个GDTMobBannerView的实例
}
@end
