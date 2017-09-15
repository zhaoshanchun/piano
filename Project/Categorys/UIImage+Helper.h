//
//  UIImage+Helper.h
//  OpenSnap
//
//  Created by hangyuen on 30/9/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)circleImageWithColor:(UIColor *)color radius:(CGFloat)radius;

+ (UIImage *)imageNamedWithScreenWidth:(NSString *)name;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

- (UIImage *)resizableImageWithSize:(CGSize)size;

- (UIImage *)croppedImageWithRect:(CGRect)cropRect;

- (UIImage *)scaledToSize:(CGSize)newSize;

//- (UIImage *)resizeForUploadIfNeeded;

- (UIImage *)scaledToBoundedSize:(CGFloat)size;

- (UIImage *)placeHolderWithSize:(CGSize)size;

- (CGSize)testImageResultSizeByScalingProportionallyToSize:(CGSize)targetSize;

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;

- (UIImage *)imageByCroppingToSize:(CGSize)size;

- (UIImage *)tintImageWithColor:(UIColor *)tintColor;

- (UIImage *)imageWithBackgroundColor:(UIColor *)backgroundColor;

- (NSData *)getImageDataForCompressionQuality:(CGFloat)quailty withExifMetaData:(NSDictionary *)metadata;

- (UIImage *)imageWithMaskImage:(UIImage *)maskImage;

- (UIImage *)imageWithVerticalProportion:(CGFloat)proportion withBlurEffect:(BOOL)withBlurEffect andMaskColor:(UIColor *)maskColor;

@end
