//
//  AnPush.h
//  AnPush
//
//  Created by Arrownock on 1/19/13.
//  Copyright (c) 2013 Arrownock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol AnPushDelegate <NSObject>

@optional
- (void)didRegistered:(NSString *)anid withError:(NSString *)error;
- (void)didUnregistered:(BOOL)success withError:(NSString *)error;
- (void)didSetMute:(BOOL)success withError:(NSString *)error;
- (void)didClearMute:(BOOL)success withError:(NSString *)error;
- (void)didSetSilent:(BOOL)success withError:(NSString *)error;
- (void)didClearSilent:(BOOL)success withError:(NSString *)error;
@end

@interface AnPush : NSObject
+ (AnPush *)shared;
+ (void)registerForPushNotification:(UIRemoteNotificationType)types;
+ (void)setup:(NSString *)appKey deviceToken:(NSData *)deviceToken delegate:(id <AnPushDelegate>)delegate secure:(BOOL)secure;

- (void)register:(NSArray *)channels overwrite:(BOOL)overwrite;
- (void)unregister;
- (void)unregister:(NSArray *)channels;
- (void)setMute;
- (void)setMuteWithHour:(NSInteger)startHour minute:(NSInteger)startMinute duration:(NSInteger)duration;
- (void)clearMute;
- (void)setSilentWithHour:(NSInteger)startHour minute:(NSInteger)startMinute duration:(NSInteger)duration resend:(BOOL)resend;
- (void)clearSilent;
- (NSString *)getAnID;
@end
