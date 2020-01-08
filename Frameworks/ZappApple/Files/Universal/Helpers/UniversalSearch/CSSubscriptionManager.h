//
//  CSSubscriptionManager.h
//  ZappApple
//
//  Created by Anton Kononenko on 8/12/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSSubscriptionManager : NSObject

+ (CSSubscriptionManager *)sharedManager;

- (void)registerSubscriptionWithInfo:(NSString *)subscriptionInfo expirationDate:(NSDate *)expirationDate;
- (void)unregisterSubscriptionWithInfo:(NSString *)subscriptionInfo;
- (void)unregisterAllSubscriptions;

@end
