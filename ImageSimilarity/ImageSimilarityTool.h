//
//  ImageSimilarityTool.h
//  ImageSimilarity
//
//  Created by Blavtes on 2017/8/9.
//  Copyright © 2017年 Blavtes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageSimilarityTool : NSObject
+ (NSString *)compareImage:(UIImage *)originImage source:(UIImage *)sourceImage;
+ (UIImage *)covertToGrayScale:(UIImage *)originImage source:(UIImage *)sourceImage;
+ (UIImage*)getGrayImage:(UIImage*)sourceImage;

+ (UIImage*)getGrayImage:(UIImage*)sourceImage origin:(UIImage *)orimage;
+ (UIImage *)normalizationImage:(UIImage *)sourceImage;
@end
