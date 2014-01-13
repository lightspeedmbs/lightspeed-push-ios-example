//
//  LightspeedAPIManager.h
//  LSPush
//
//  Created by Bobie Chen on 2014/1/13.
//  Copyright (c) 2014年 Herxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LightspeedAPIManager : NSObject

+ (LightspeedAPIManager*)sharedLightspeedAPIManager;
- (void)sendHTTPRequest:(NSString*)strAPI payload:(NSString*)strPayload completion:(void (^)(BOOL, NSDictionary*, NSError*))completion;

@end
