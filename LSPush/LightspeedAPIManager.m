//
//  LightspeedAPIManager.m
//  LSPush
//
//  Created by Bobie Chen on 2014/1/13.
//  Copyright (c) 2014年 Herxun. All rights reserved.
//

#import "LightspeedAPIManager.h"

#define LIGHTSPEED_API_BASEURL              @"http://api.lightspeedmbs.com/v1"
#define LIGHTSPEED_API_HTTP_METHOD          @"POST"
#define LIGHTSPEED_API_LOGIN                @"admins/login.json"
#define LIGHTSPEED_API_SEND_PUSH            @"push_notification/send.json"

static LightspeedAPIManager* m_pLightspeedAPIManager;

@implementation LightspeedAPIManager

+ (LightspeedAPIManager*)sharedLightspeedAPIManager
{
    if (!m_pLightspeedAPIManager)
    {
        m_pLightspeedAPIManager = [[LightspeedAPIManager alloc] init];
    }
    
    return m_pLightspeedAPIManager;
}

- (void)sendHTTPRequest:(NSString*)strAPI payload:(NSString*)strPayload completion:(void (^)(BOOL, NSDictionary*, NSError*))completion
{
    if (!strAPI || [strAPI isEqualToString:@""])
    {
        return;
    }
    
    NSString* strAPIPath = [NSString stringWithFormat:@"%@/%@", LIGHTSPEED_API_BASEURL, strAPI];
    
    NSURL* requestURL = [NSURL URLWithString:strAPIPath];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [request setHTTPMethod:LIGHTSPEED_API_HTTP_METHOD];
    if (strPayload && ![strPayload isEqualToString:@""])
    {
        NSData* postData = [strPayload dataUsingEncoding:NSUTF8StringEncoding];
        NSString* postDataLengthString = [NSString stringWithFormat:@"%d", [postData length]];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:postDataLengthString forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
        if (error)
        {
            NSLog(@"Fail to search Google Nearby places. Error: %@", [error localizedDescription]);
            if (completion)
                completion(NO, nil, error);
        }
        else
        {
            NSDictionary* dictData = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableLeaves
                                                                       error:nil];
            
            NSDictionary* dictMeta = [dictData objectForKey:@"meta"];
            if (dictMeta)
            {
                if ([[dictMeta objectForKey:@"code"] intValue] == 200)
                {
                    if (completion)
                    {
                        completion(YES, dictMeta, nil);
                    }
                }
                else
                {
                    if (completion)
                    {
                        completion(NO, dictMeta, nil);
                    }
                }
            }
        }
    }];
}

@end
