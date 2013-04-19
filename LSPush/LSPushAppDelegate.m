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

@implementation LSPushAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AnPush registerForPushNotification:(UIRemoteNotificationTypeAlert|
                                         UIRemoteNotificationTypeBadge|
                                         UIRemoteNotificationTypeSound)];
    
    return YES;
}

#pragma mark - Lightspeed push-notification registration result handler
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [AnPush setup:kArrownockAppKey deviceToken:deviceToken delegate:self secure:YES];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification!");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if (application.applicationState == UIApplicationStateActive)
    {
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
    ViewController* mainViewController = (ViewController*)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    mainViewController.btnPush.enabled = YES;
}

- (void)didUnregistered:(BOOL)success withError:(NSString *)error
{
    NSLog(@"Unregistration success: %@\nError: %@", success? @"YES" : @"NO", error);
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