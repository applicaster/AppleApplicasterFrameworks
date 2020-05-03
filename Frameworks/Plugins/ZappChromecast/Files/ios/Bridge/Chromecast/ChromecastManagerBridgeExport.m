//
//  ZPAppleVideoSubscriberSSOBridgeExport.m
//  ZappGeneralPluginChromecast
//
//  Created by Alex Zchut on 31/03/2020.
//  Copyright © 2020 Applicaster. All rights reserved.
//

@import React;

@interface RCT_EXTERN_MODULE(RNGoogleCast, NSObject)

RCT_EXTERN_METHOD(showIntroductoryOverlay)
RCT_EXTERN_METHOD(launchExpandedControls)
RCT_EXTERN_METHOD(castMedia:(NSDictionary *)params);
RCT_EXTERN_METHOD(getCastState:(RCTPromiseResolveBlock)resolve rejecter: (RCTPromiseRejectBlock) reject);

@end

