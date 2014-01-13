//
//  LSPushAppDelegate.m
//  LSPush
//
//  Created by Bobie@herxun.co on 4/17/13.
//  Copyright (c) 2013 Herxun. All rights reserved.
//

#import "LSPushAppDelegate.h"
#import "ViewController.h"
#import "LightspeedCredentials.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation LSPushAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    return YES;
}

- (void)registerForRemoteNotifications
{
    [AnPush registerForPushNotification:(UIRemoteNotificationTypeAlert|
                                         UIRemoteNotificationTypeBadge|
                                         UIRemoteNotificationTypeSound)];
}

- (void)unregisterRemoteNotifications
{
    AnPush* anPush;
    @try {
        anPush = [AnPush shared];
    }
    @catch (NSException *exception) {
        anPush = nil;
    }
    @finally {
        
    }
    
    if (anPush)
    {
        
    }
}

#pragma mark - Lightspeed push-notification registration result handler
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [AnPush setup:kArrownockAppKey deviceToken:deviceToken delegate:self secure:YES];
    
    /* register channels */
    NSArray* arrayChannels = [NSArray arrayWithObjects:@"BroadcastMessage", @"LightspeedNews", nil ];
    
    AnPush* anPush;
    @try {
        anPush = [AnPush shared];
    }
    @catch (NSException *exception) {
        anPush = nil;
    }
    @finally {
        
    }
    
    if (anPush)
    {
        [anPush register:arrayChannels overwrite:YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"co.herxun.LSPush.registerRemoteNotificationResult" object:@"Lightspeed Push might not have been properly set up"];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"co.herxun.LSPush.registerRemoteNotificationResult" object:[error localizedDescription]];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification!");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if (application.applicationState == UIApplicationStateActive)
    {
        AudioServicesPlaySystemSound(1002);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Lightspeed"
                                                        message:(NSString*)[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - AnPushDelegate functions
- (void)didRegistered:(NSString *)anid withError:(NSString *)error
{
    NSLog(@"Arrownock didRegistered\nError: %@", error);
    if (error && ![error isEqualToString:@""])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"co.herxun.LSPush.registerRemoteNotificationResult" object:error];
    }
    else if (!anid || [anid isEqualToString:@""])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"co.herxun.LSPush.registerRemoteNotificationResult" object:@"Invalid Lightspeed ID"];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"co.herxun.LSPush.registerRemoteNotificationResult" object:nil];
    }
}

- (void)didUnregistered:(BOOL)success withError:(NSString *)error
{
    NSLog(@"Unregistration success: %@\nError: %@", success? @"YES" : @"NO", error);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"co.herxun.LSPush.unregisterRemoteNotificationResult" object:(success)? nil : error];
}

#pragma mark - Application life-cycle management
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
