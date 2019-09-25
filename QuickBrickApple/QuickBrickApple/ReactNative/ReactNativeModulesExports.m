//
//  ReactNativeModulesExports.m
//  ZappTvOS
//
//  Created by François Roland on 20/11/2018.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

@import React;

@interface RCT_EXTERN_MODULE(QuickBrickCommunicationModule, NSObject)

RCT_EXTERN_METHOD(quickBrickEvent:(NSString *)eventName payload:(NSDictionary *)payload);

@end

@interface RCT_EXTERN_MODULE(AnalyticsBridge, NSObject)
RCT_EXTERN_METHOD(postEvent:(NSString *)event payload:(NSDictionary *)payload);
RCT_EXTERN_METHOD(postTimedEvent:(NSString *)event payload:(NSDictionary *)payload);
RCT_EXTERN_METHOD(endTimedEvent:(NSString *)event payload:(NSDictionary *)payload);
@end

@interface RCT_EXTERN_MODULE(SessionStorage, NSObject)
RCT_EXTERN_METHOD(setItem:(NSString *)key value:(NSString *)value namespace:(NSString *)namespace resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter);
RCT_EXTERN_METHOD(getItem:(NSString *)key namespace:(NSString *)namespace resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter);
RCT_EXTERN_METHOD(getAllItems:(NSString *)namespace resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter);

@end

@interface RCT_EXTERN_MODULE(LocalStorage, NSObject)
RCT_EXTERN_METHOD(setItem:(NSString *)key value:(NSString *)value namespace:(NSString *)namespace resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter);
RCT_EXTERN_METHOD(getItem:(NSString *)key namespace:(NSString *)namespace resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter);
RCT_EXTERN_METHOD(getAllItems:(NSString *)namespace resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter);
@end


