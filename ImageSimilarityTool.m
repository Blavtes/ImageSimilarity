//
//  ImageSimilarityTool.m
//  ImageSimilarity
//
//  Created by Blavtes on 2017/8/9.
//  Copyright © 2017年 Blavtes. All rights reserved.
//

#import "ImageSimilarityTool.h"
#import <UIKit/UIKit.h>

@implementation ImageSimilarityTool

+ (NSString *)compareImage:(UIImage *)originImage source:(UIImage *)sourceImage
{
    UIImage *a1  =[self originImage:originImage scaleToSize:CGSizeMake(8, 8)];
    UIImage *b1 = [self originImage:sourceImage scaleToSize:CGSizeMake(8, 8)];
    
    UIImage *a2 = [self getGrayImage:a1];
    UIImage *b2 = [self getGrayImage:b1];
    
    NSString *ha = [self myHash:a2];
    NSString *hb = [self myHash:b2];
    NSString *r1 = [self checkoutImageSimilarity:ha compare:hb];
    return r1;
}

//对比指纹
+ (NSString *)checkoutImageSimilarity:(NSString *)hash1 compare:(NSString *)hash2
{
    int count = 0;
    for (int i = 0; i < hash1.length; i++) {
        NSString *s = [hash1 substringWithRange:NSMakeRange(i, 1)];
        NSString *o = [hash2 substringWithRange:NSMakeRange(i, 1)];
        if (![s isEqualToString:o]) {
            count ++;
        }
    }
    float resout = (1 - count / 64.0f) * 100;
    return [NSString stringWithFormat:@"%.4f%%",resout];
}
//缩小尺寸。将图片缩小到8x8的尺寸，总共64个像素、 去除图片的细节，只保留结构、明暗等基本信息，摒弃不同尺寸、比例带来的图片差异。
+ (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}

//简化色彩。将缩小后的图片，转为64级灰度。
+ (UIImage*)getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

//计算平均值。计算所有64个像素的灰度平均值。
+ (unsigned char*)grayscalePixels:(UIImage *) image
{
    // The amount of bits per pixel, in this case we are doing grayscale so 1 byte = 8 bits
#define BITS_PER_PIXEL 8
    // The amount of bits per component, in this it is the same as the bitsPerPixel because only 1 byte represents a pixel
#define BITS_PER_COMPONENT (BITS_PER_PIXEL)
    // The amount of bytes per pixel, not really sure why it asks for this as well but it's basically the bitsPerPixel divided by the bits per component (making 1 in this case)
#define BYTES_PER_PIXEL (BITS_PER_PIXEL/BITS_PER_COMPONENT)
    
    // Define the colour space (in this case it's gray)
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceGray();
    
    // Find out the number of bytes per row (it's just the width times the number of bytes per pixel)
    size_t bytesPerRow = image.size.width * BYTES_PER_PIXEL;
    // Allocate the appropriate amount of memory to hold the bitmap context
    unsigned char* bitmapData = (unsigned char*) malloc(bytesPerRow*image.size.height);
    
    // Create the bitmap context, we set the alpha to none here to tell the bitmap we don't care about alpha values
    CGContextRef context = CGBitmapContextCreate(bitmapData,image.size.width,image.size.height,BITS_PER_COMPONENT,bytesPerRow,colourSpace,kCGImageAlphaNone);
    
    // We are done with the colour space now so no point in keeping it around
    CGColorSpaceRelease(colourSpace);
    
    // Create a CGRect to define the amount of pixels we want
    CGRect rect = CGRectMake(0.0,0.0,image.size.width,image.size.height);
    // Draw the bitmap context using the rectangle we just created as a bounds and the Core Graphics Image as the image source
    CGContextDrawImage(context,rect,image.CGImage);
    // Obtain the pixel data from the bitmap context
    unsigned char* pixelData = (unsigned char*)CGBitmapContextGetData(context);
    
    // Release the bitmap context because we are done using it
    CGContextRelease(context);
    
    return pixelData;
#undef BITS_PER_PIXEL
#undef BITS_PER_COMPONENT
}

//得到指纹
+ (NSString *) myHash:(UIImage *) img
{
    unsigned char* pixelData = [self grayscalePixels:img];
    
    int total = 0;
    int ave = 0;
    for (int i = 0; i < img.size.height; i++) {
        for (int j = 0; j < img.size.width; j++) {
            total += (int)pixelData[(i*((int)img.size.width))+j];
        }
    }
    ave = total/64;
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < img.size.height; i++) {
        for (int j = 0; j < img.size.width; j++) {
            int a = (int)pixelData[(i*((int)img.size.width))+j];
            if(a >= ave)
            {
                [result appendString:@"1"];
            }
            else
            {
                [result appendString:@"0"];
            }
        }
    }
    return result;
}


@end
