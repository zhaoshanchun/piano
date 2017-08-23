//
//  UIImage+Helper.m
//  OpenSnap
//
//  Created by hangyuen on 30/9/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import "UIImage+Helper.h"
// #import "FXBlurView.h"

@implementation UIImage (Helper)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)circleImageWithColor:(UIColor *)color radius:(CGFloat)radius {
    CGRect rect = CGRectMake(0, 0, radius * 2, radius * 2);

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillEllipseInRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageNamedWithScreenWidth:(NSString *)name {
    if ([name hasSuffix:@"jpg"]) {
        name = [name stringByReplacingOccurrencesOfString:@".jpg"
                                               withString:[NSString stringWithFormat:@"%.0f.jpg", [UIScreen mainScreen].bounds.size.width]];
        return [UIImage imageNamed:name];
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@%.0f", name, [UIScreen mainScreen].bounds.size.width];
    return [UIImage imageNamed:imageName];
}

- (UIImage *)imageWithCornerRadius:(CGFloat)radius {
    CGSize targetSize = self.size;
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 1.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, targetSize.width, targetSize.height)
                                cornerRadius:3.0] addClip];
    
    // Draw your image
    [self drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    
    // Get the image, here setting the UIImageView image
    UIImage* clippedBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    // Do what we came here to do
    return clippedBackgroundImage;
}

- (UIImage *)scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//- (UIImage *)resizeForUploadIfNeeded {
//    if (self.size.width > kPhotoUploadMaxSize || self.size.height > kPhotoUploadMaxSize) {
//        if (self.size.height >= self.size.width) {
//            return [self scaledToSize:(CGSize){ kPhotoUploadMaxSize, kPhotoUploadMaxSize * self.size.height / self.size.width }];
//        } else {
//            return [self scaledToSize:(CGSize){ kPhotoUploadMaxSize * self.size.width / self.size.height, kPhotoUploadMaxSize }];
//        }
//    } else {
//        return self;
//    }
//}

- (UIImage *)scaledToBoundedSize:(CGFloat)size {
    if (self.size.width >= self.size.height) {
        return [self scaledToSize:(CGSize) { size*self.size.width/self.size.height, size }];
    } else {
        return [self scaledToSize:(CGSize) { size, size*self.size.height/self.size.width }];
    }
}

- (UIImage *) resizableImageWithSize:(CGSize)size {
//    if( [self respondsToSelector:@selector(resizableImageWithCapInsets:)] ) {
//        return [self resizableImageWithCapInsets:UIEdgeInsetsMake(size.height, size.width, size.height, size.width)];
//    } else {
        return [self stretchableImageWithLeftCapWidth:size.width topCapHeight:size.height];
//    }
}

- (UIImage *)croppedImageWithRect:(CGRect)cropRect {
    UIGraphicsBeginImageContextWithOptions(cropRect.size, NO, 1);
    [self drawAtPoint:(CGPoint){-cropRect.origin.x, -cropRect.origin.y}];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return croppedImage;
}

- (UIImage *)placeHolderWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 232/255, 232/255, 232/255, 1);
    [self drawAtPoint:CGPointMake((size.width - self.size.width) / 2.0f, (size.height - self.size.height) / 2.0f)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}


//
- (CGSize)testImageResultSizeByScalingProportionallyToSize:(CGSize)targetSize
{
    
    UIImage *sourceImage = self;
    //UIImage *newImage = nil;
    
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
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    if(isnan(scaledWidth))  scaledWidth = 0;
    if(isnan(scaledHeight))  scaledHeight = 0;
    
    return CGSizeMake(scaledWidth, scaledHeight);
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
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
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 1.0);

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    // DLog(@"imageByScalingProportionallyToSize -- Rect :%@",NSStringFromCGRect(thumbnailRect));
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) MyLog(@"could not scale image");
    
    
    return newImage ;
}

- (UIImage *)imageByCroppingToSize:(CGSize)size {
    // not equivalent to image.size (which depends on the imageOrientation)
    double refWidth = CGImageGetWidth(self.CGImage);
    double refHeight = CGImageGetHeight(self.CGImage);
    
    double x = (refWidth - size.width) / 2.0;
    double y = (refHeight - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (UIImage *) tintImageWithColor:(UIColor *)tintColor
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, self.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [tintColor setFill];
    CGContextFillRect(context, rect);
    
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImage;
}

- (UIImage *)imageWithBackgroundColor:(UIColor *)backgroundColor {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, rect);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, self.CGImage);
    
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImage;
}

- (NSData *)getImageDataForCompressionQuality:(CGFloat)quailty withExifMetaData:(NSDictionary *)metadata {
    NSData *imageData = UIImageJPEGRepresentation(self, quailty);
    
    if (metadata == nil) return imageData;
    
    // create an imagesourceref
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef) imageData, NULL);
    
    // this is the type of image (e.g., public.jpeg)
    CFStringRef UTI = CGImageSourceGetType(source);
    
    // create a new data object and write the new image into it
    NSMutableData *dest_data = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)dest_data, UTI, 1, NULL);
    
    if (!destination) {
        MyLog(@"Error: Could not create image destination");
    }
    
    // add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef) metadata);
    BOOL success = NO;
    success = CGImageDestinationFinalize(destination);
    
    if (!success) {
        MyLog(@"Error: Could not create data from image destination");
    }
    
    CFRelease(destination);
    CFRelease(source);
    
    return dest_data;
}

- (UIImage *)imageWithMaskImage:(UIImage *)maskImage {
    CGRect imageRect = (CGRect){ 0, 0, self.size };
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    [self drawInRect:imageRect];
    if (maskImage) {
        [maskImage drawInRect:imageRect];
    }
    UIImage *imageWithMask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageWithMask;
}

- (UIImage *)imageWithVerticalProportion:(CGFloat)proportion withBlurEffect:(BOOL)withBlurEffect andMaskColor:(UIColor *)maskColor {
    CGRect topRect = (CGRect){ 0, 0, self.size.width, self.size.height * (withBlurEffect ? proportion :1) };
    CGRect blurredRect = (CGRect){ 0, self.size.height*proportion, self.size.width, self.size.height*(1-proportion) };
    UIImage *topImage = [self croppedImageWithRect:topRect];
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    [topImage drawInRect:CGRectMake(0, 0, self.size.width, topImage.size.height)];
    
//    if (withBlurEffect) {
//        UIImage *blurredImage = [[self croppedImageWithRect:blurredRect] blurredImageWithRadius:10 iterations:10 tintColor:[UIColor clearColor]];
//        [blurredImage drawInRect:CGRectMake(0, topImage.size.height, self.size.width, blurredImage.size.height)];
//    }
    if (maskColor) {
        UIImage *maskImage = [UIImage imageWithColor:maskColor size:blurredRect.size];
        [maskImage drawInRect:CGRectMake(0, (withBlurEffect ? topImage.size.height : topImage.size.height*proportion), self.size.width, maskImage.size.height)];
    }
    UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return combinedImage;
}

@end
