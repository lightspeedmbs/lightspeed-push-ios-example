//
//  UICommonUtility.h
//  HappyTime
//
//  Created by Bobie on 4/22/13.
//  Copyright (c) 2013 Herxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UICommonUtility : NSObject

+ (CGSize)getScreenSize;
+ (NSArray*)hexToRGB:(NSUInteger)hexValue;
+ (UIColor*)hexToColor:(NSUInteger)hexValue withAlpha:(NSNumber*)alpha;
+ (NSString*)getiOSVersion;

@end
