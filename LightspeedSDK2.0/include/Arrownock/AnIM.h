//
//  AnIM.h
//  AnIM
//
//  Created by Edward Sun on 4/11/13.
//  Copyright (c) 2013 arrownock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AnIM;
@protocol AnIMDelegate <NSObject>

@optional
- (void)anIM:(AnIM *)anIM didGetClientId:(NSString *)clientId error:(NSString *)error;
- (void)anIM:(AnIM *)anIM didUpdateStatus:(BOOL)status;

- (void)anIM:(AnIM *)anIM messageSent:(NSString *)messageId;
- (void)anIM:(AnIM *)anIM messageReceived:(NSString *)messageId;
- (void)anIM:(AnIM *)anIM messageRead:(NSString *)messageId;

- (void)anIM:(AnIM *)anIM didReceiveMessage:(NSString *)message customData:(NSDictionary *)customData from:(NSString *)from parties:(NSArray *)parties messageId:(NSString *)messageId;
- (void)anIM:(AnIM *)anIM didReceiveBinary:(NSData *)data fileType:(NSString *)fileType customData:(NSDictionary *)customData from:(NSString *)from parties:(NSArray *)parties messageId:(NSString *)messageId;
- (void)anIM:(AnIM *)anIM didReceiveMessage:(NSString *)message customData:(NSDictionary *)customData from:(NSString *)from topicId:(NSString *)topicId messageId:(NSString *)messageId;
- (void)anIM:(AnIM *)anIM didReceiveBinary:(NSData *)data fileType:(NSString *)fileType customData:(NSDictionary *)customData from:(NSString *)from topicId:(NSString *)topicId messageId:(NSString *)messageId;
- (void)anIM:(AnIM *)anIM didReceiveNotice:(NSString *)notice customData:(NSDictionary *)customData from:(NSString *)from messageId:(NSString *)messageId;

- (void)anIM:(AnIM *)anIM didCreateTopic:(NSString *)topicId error:(NSString *)error;
- (void)anIM:(AnIM *)anIM didAddClients:(NSString *)error;
- (void)anIM:(AnIM *)anIM didRemoveClients:(NSString *)error;
- (void)anIM:(AnIM *)anIM didGetTopicInfo:(NSString *)topicId name:(NSString *)topicName parties:(NSArray *)parties createdDate:(NSDate *)createdDate error:(NSString *)error;
- (void)anIM:(AnIM *)anIM didGetTopicLog:(NSArray *)logs error:(NSString *)error;

- (void)anIM:(AnIM *)anIM didBindService:(NSString *)error;
- (void)anIM:(AnIM *)anIM didUnbindService:(NSString *)error;

- (void)anIM:(AnIM *)anIM didGetClientsStatus:(NSDictionary *)clientsStatus error:(NSString *)error;
@end


typedef enum {
    AnPushTypeiOS,
    AnPushTypeAndroid,
    AnPushTypeWP8
} AnPushType;


@interface AnIM : NSObject
- (AnIM *)initWithAppKey:(NSString *)appKey delegate:(id <AnIMDelegate>)delegate secure:(BOOL)secure;

- (void)getClientId:(NSString *)userId;
- (void)connect:(NSString *)clientId;
- (void)disconnect;

- (NSString *)sendMessage:(NSString *)message toClients:(NSArray *)clientIds needReceiveACK:(BOOL)need;
- (NSString *)sendMessage:(NSString *)message customData:(NSDictionary *)customData toClients:(NSArray *)clientIds needReceiveACK:(BOOL)need;
- (NSString *)sendBinary:(NSData *)data fileType:(NSString *)fileType toClients:(NSArray *)clientIds needReceiveACK:(BOOL)need;
- (NSString *)sendBinary:(NSData *)data fileType:(NSString *)fileType customData:(NSDictionary *)customData toClients:(NSArray *)clientIds needReceiveACK:(BOOL)need;

- (NSString *)sendMessage:(NSString *)message toTopicId:(NSString *)topicId needReceiveACK:(BOOL)need;
- (NSString *)sendMessage:(NSString *)message customData:(NSDictionary *)customData toTopicId:(NSString *)topicId needReceiveACK:(BOOL)need;
- (NSString *)sendBinary:(NSData *)data fileType:(NSString *)fileType toTopicId:(NSString *)topicId needReceiveACK:(BOOL)need;
- (NSString *)sendBinary:(NSData *)data fileType:(NSString *)fileType customData:(NSDictionary *)customData toTopicId:(NSString *)topicId needReceiveACK:(BOOL)need;

- (NSString *)sendNotice:(NSString *)notice toClients:(NSArray *)clientIds needReceiveACK:(BOOL)need;
- (NSString *)sendNotice:(NSString *)notice customData:(NSDictionary *)customData toClients:(NSArray *)clientIds needReceiveACK:(BOOL)need;
- (NSString *)sendNotice:(NSString *)notice toTopicId:(NSString *)topicId needReceiveACK:(BOOL)need;
- (NSString *)sendNotice:(NSString *)notice customData:(NSDictionary *)customData toTopicId:(NSString *)topicId needReceiveACK:(BOOL)need;

- (NSString *)sendReadACK:(NSString *)messageId toClients:(NSArray *)clientIds;

- (void)createTopic:(NSString *)topic;
- (void)createTopic:(NSString *)topic withClients:(NSArray *)clientIds;
- (void)addClients:(NSArray *)clientIds toTopicId:(NSString *)topicId;
- (void)removeClients:(NSArray *)clientIds fromTopicId:(NSString *)topicId;
- (void)getTopicInfo:(NSString *)topicId;
- (void)getTopicLog:(NSString *)topicId start:(NSDate *)start end:(NSDate *)end;

- (void)bindAnPushService:(NSString *)anId appKey:(NSString *)appKey deviceType:(AnPushType)deviceType;
- (void)unbindAnPushService:(AnPushType)deviceType;

- (void)getClientsStatus:(NSArray *)clientIds;
@end
