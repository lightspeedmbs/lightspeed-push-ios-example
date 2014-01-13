//
//  UICommonUtility.m
//  HappyTime
//
//  Created by Bobie on 4/22/13.
//  Copyright (c) 2013 Herxun. All rights reserved.
//

#import "UICommonUtility.h"

@implementation UICommonUtility

+ (CGSize)getScreenSize
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    
    return screenBound.size;
}

+ (NSArray*)hexToRGB:(NSUInteger)hexValue
{
    NSNumber* red = [NSNumber numberWithInt:(hexValue>>16)];
    NSNumber* green = [NSNumber numberWithInt:((hexValue >> 8) & 0xFF)];
    NSNumber* blue = [NSNumber numberWithInt:(hexValue & 0xFF)];
    NSArray* arrayRGB = [[NSArray alloc] initWithObjects:red, green, blue, nil];
    
    return arrayRGB;
}

+ (UIColor*)hexToColor:(NSUInteger)hexValue withAlpha:(NSNumber*)alpha
{
    NSNumber* red = [NSNumber numberWithInt:(hexValue>>16)];
    NSNumber* green = [NSNumber numberWithInt:((hexValue >> 8) & 0xFF)];
    NSNumber* blue = [NSNumber numberWithInt:(hexValue & 0xFF)];
    
    float fAlpha = (alpha)? [alpha floatValue] : 1.0f;
    UIColor* color = [UIColor colorWithRed:[red floatValue]/255.0f green:[green floatValue]/255.0f blue:[blue floatValue]/255.0f alpha:fAlpha];
    
    return color;
}

+ (NSString*)getiOSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

@end
