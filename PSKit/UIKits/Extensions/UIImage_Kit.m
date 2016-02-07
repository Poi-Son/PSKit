//
//  UIImage+Kit.m
//  PSKit
//
//  Created by PoiSon on 15/9/22.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "PSFoudation.h"
#import "UIView_Kit.h"

@implementation UIImage (Kit)
- (instancetype)ps_imageResized{
    CGFloat wCap = 3.5f;
    CGFloat hCap = 3.5f;
    return [self stretchableImageWithLeftCapWidth:wCap topCapHeight:hCap];
}

+ (instancetype)ps_imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (instancetype)ps_imageWithSize:(CGSize)size fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor byGradientType:(PSGradientType)gradientType{
        
        UIGraphicsBeginImageContextWithOptions(size, YES, 1);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGColorSpaceRef colorSpace = CGColorGetColorSpace([toColor CGColor]);//Get 不需要释放 Create需要释放
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)@[(id)fromColor.CGColor,(id)toColor.CGColor], NULL);
        CGPoint start;
        CGPoint end;
        switch (gradientType) {
            case 0:
                start = CGPointMake(0.0, 0.0);
                end = CGPointMake(0.0, size.height);
                break;
            case 1:
                start = CGPointMake(0.0, 0.0);
                end = CGPointMake(size.width, 0.0);
                break;
            case 2:
                start = CGPointMake(0.0, 0.0);
                end = CGPointMake(size.width, size.height);
                break;
            case 3:
                start = CGPointMake(size.width, 0.0);
                end = CGPointMake(0.0, size.height);
                break;
            default:
                break;
        }
        CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        CGGradientRelease(gradient);
        CGContextRestoreGState(context);
        UIGraphicsEndImageContext();
        return image;
}

+ (instancetype)ps_imageNamed:(NSString *)name withTintColor:(UIColor *)color{
    static NSMapTable *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [NSMapTable strongToWeakObjectsMapTable];
    });
    NSString *imageKey = [NSString stringWithFormat:@"%@$%@", name, [color ps_hexString]];
    UIImage *image = [cache objectForKey:imageKey];
    returnValIf(image, image);
    //缓存
    image = [self ps_imageWithImage:[UIImage imageNamed:name] tintColor:color];
    [cache setObject:image forKey:imageKey];
    return image;
}

+ (instancetype)ps_imageWithImage:(UIImage *)image tintColor:(UIColor *)color{
    UIImageView *targetImageView = [[UIImageView alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    targetImageView.tintColor = color;
    return [targetImageView ps_snapshot];
}
@end
