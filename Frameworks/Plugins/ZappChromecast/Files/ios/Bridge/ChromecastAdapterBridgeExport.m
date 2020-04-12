//
//  ChromecastAdapterBridgeExport.m
//  ZappGeneralPluginChromecast
//
//  Created by Alex Zchut on 29/03/2020.
//  Copyright © 2020 Applicaster. All rights reserved.
//

@import React;
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(ChromecastButton, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(key, NSString);
RCT_EXPORT_VIEW_PROPERTY(color, UIColor);
RCT_EXPORT_VIEW_PROPERTY(width, float);

@end
