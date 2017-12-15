//
//  DDCalculateImageValue.m
//  Camera_Test
//
//  Created by wheng on 17/4/20.
//  Copyright © 2017年 admin. All rights reserved.
//

#define BitOperation(x) ( (x) & 0xFF )
#define R(x) ( BitOperation(x) )
#define G(x) ( BitOperation(x >> 8 ) )
#define B(x) ( BitOperation(x >> 16) )
#define A(x) ( BitOperation(x >> 24) )


#import "DDCalculateImageValue.h"
#include "HSV.h"

@implementation DDCalculateImageValue

+ (void)calculateImage:(UIImage *)image compressTargetSize:(CGSize)size value:(void (^)(CGFloat))valueBlock {
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CGImageRef cgimage = image.CGImage;
        if (!CGSizeEqualToSize(size, CGSizeZero)) {
            cgimage = [DDCalculateImageValue imageCompressByScaleSize:size withSourceImage:image].CGImage;
        }
        
        NSUInteger width    = CGImageGetWidth(cgimage); // 图片宽度
        NSUInteger height   = CGImageGetHeight(cgimage); // 图片高度
        UInt32 *pixels      = (UInt32 *) calloc(width * height, sizeof(UInt32)); // 取图片首地址
        NSUInteger bitsPerComponent = 8; // r g b a 每个component bits数目
        NSUInteger bytesPerRow      = width * 4; // 一张图片每行字节数目 (每个像素点包含r g b a 四个字节)
        CGColorSpaceRef space   = CGColorSpaceCreateDeviceRGB(); // 创建rgb颜色空间
        
        CGContextRef context    =
        CGBitmapContextCreate(pixels,
                              width,
                              height,
                              bitsPerComponent,
                              bytesPerRow,
                              space,
                              kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgimage);
        
        NSInteger greenValue = 0;
        UInt32 *currentPixel = pixels;
        for (size_t i = 0; i < height; i++) {
            for (size_t j = 0; j < width; j++) {
                UInt32 color    = *currentPixel;
                float red       = R(color);
                float green     = G(color);
                float blue      = B(color);
                currentPixel++;
                HSVType hsv     = RGB_to_HSV(RGBTypeMake(red, green, blue));
                if (((hsv.h >= 0 && hsv.h <= 150) || (hsv.h >= 350 && hsv.h <= 360)) && hsv.s >= 20 && hsv.s <= 100 && hsv.v >= 10 && hsv.v <= 100)
                    greenValue++;
            }
        }
        
        CGFloat resultValue = greenValue * 1.0/ (height * width) * 100;
        
        //vertify resultValue
        if (resultValue > 95)  resultValue = 95.0;

        dispatch_async(dispatch_get_main_queue(), ^{
            valueBlock(resultValue);
        });
        
    });

}

/**
 * compress image to target size
 * @param targetSize  size
 * @param sourceImage image
 * @return returnImage
 */
+ (UIImage *)imageCompressByScaleSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage {
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        else if (widthFactor < heightFactor)
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
