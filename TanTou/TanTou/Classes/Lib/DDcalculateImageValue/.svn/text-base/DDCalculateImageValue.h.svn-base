//
//  DDCalculateImageValue.h
//  Camera_Test
//
//  Created by wheng on 17/4/20.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DDCalculateImageValue : NSObject

/**传入图片(image)、压缩的大小(不压缩是CGSizeZero)、返回的值value(百分制)
 
 BASIC_calculate imagePixel

 @param image   Origin_Image
 @param size    Target_Compress_Size or CGSizeZero
 @param valueBlock returnValue Centesimal——[0, 100]
 */
+ (void)calculateImage:(UIImage * _Nonnull)image compressTargetSize:(CGSize)size value:(void(^ _Nonnull)(CGFloat value))valueBlock;

@end
