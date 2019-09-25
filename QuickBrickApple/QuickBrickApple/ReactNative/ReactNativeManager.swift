//
//  ReactNativeManager.swift
//  ZappTvOS
//
//  Created by François Roland on 20/11/2018.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//


import UIKit
import React
import os.log
import ZappPlugins

let kQBModuleName = "QuickBrickApp"
let quickBrickLogCategory = "Quick Brick"

/// React Native Manager class for Quick Brick
open class ReactNativeManager: NSObject, UserInterfaceLayerProtocol {
    
    static var applicationData:[String:Any] = [:]
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    var reactNativePackagerRoot:String?
    
    var completion:((_ viewController:UIViewController?, _ error:Error?) -> Void)?
    
    public required init(launchOptions: [UIApplication.LaunchOptionsKey : Any]?,
                         applicationData: [String : Any] = [:]) {
        super.init()
        self.launchOptions = launchOptions
        if let reactNativePackagerRoot = applicationData["reactNativePackagerRoot"] as? String {
            self.reactNativePackagerRoot = reactNativePackagerRoot
        }
        ReactNativeManager.applicationData = applicationData
    }
    
    /// url of the react server
    private let jsBundleUrl = RCTBundleURLProvider.sharedSettings()?.jsBundleURL(forBundleRoot: "index", fallbackResource: nil)
    
    ///url of the react bundle file
    private let jsBundleFile = Bundle.main.url(forResource: "main", withExtension: "jsbundle")
    
    /// React root view
    private var reactRootView: RCTRootView?
    
    private var rootViewController:UIViewController?
    
    /**
     boolean flag used to indicate whether React should use the server url or the bundle file
     only rule currently is to use the server on Debug mode, and the bundle file otherwise
     */
    private var shouldUseReactServer: Bool {
        var retVal = false

        guard let reactNativePackagerRoot = reactNativePackagerRoot else {
            return retVal
        }
        if reactNativePackagerRoot == "dev" ||
            reactNativePackagerRoot == "localhost" ||
            reactNativePackagerRoot == "localhost:8081" {
            retVal = true
        }
        
        return retVal
    }
    
    public func prepareLayerForUse(completion:@escaping (_ viewController:UIViewController?, _ error:Error?) -> Void) {
        mountReactApp(launchOptions)
        self.completion = completion
    }
    
    /**
     Creates the react bridge and the react root view. At this point, React execution starts
     - Parameter launchOptions: launchOptions coming from AppDelegate which need to be passed to React
     */
    public func mountReactApp(_ launchOptions: [AnyHashable: Any]?) {
        _ = OSLog(subsystem: "Mounting React app", category: quickBrickLogCategory)
        let reactBridge = RCTBridge(
            delegate: self as (RCTBridgeDelegate & QuickBrickManagerDelegate),
            launchOptions: launchOptions
        )

        /// Check to remove worning form Dev environment
        /// https://github.com/facebook/react-native/issues/16376
        #if RCT_DEV
        reactBridge?.module(for: RCTDevLoadingView.self)
        #endif
        reactRootView = RCTRootView(
            bridge: reactBridge,
            moduleName: kQBModuleName,
            initialProperties: nil)
        
        reactRootView?.backgroundColor = UIColor.clear
    }
    
    public func reactNativeViewController() -> UIViewController {
        _ = OSLog(subsystem: "Presenting React controller", category: quickBrickLogCategory)
        if rootViewController == nil {
            let quickBrickViewController = UIViewController()
            if let reactView = reactRootView {
                quickBrickViewController.view = reactView
                rootViewController = quickBrickViewController
            }
        }
        return rootViewController!
    }
}

extension ReactNativeManager: RCTBridgeDelegate {
    
    /**
     returns the url location of the react code
     - parameter bridge: RCTBridge instance used to launch react
     - returns: url of the react code (server or bundle file)
     */
    public func sourceURL(for bridge: RCTBridge?) -> URL? {
        if (shouldUseReactServer) {
            return jsBundleUrl
        }
        
        if let bundleFile = jsBundleFile {
            return bundleFile
        }
        return nil
    }
}

extension ReactNativeManager: QuickBrickManagerDelegate {
    func setQuickBrickReady() {
        completion?(reactNativeViewController(), nil)
        completion = nil
    }
    
    
    /// Force application to moove to bakckground
    func moveAppToBackground() {
        DispatchQueue.main.async {
            UIApplication.shared.performSelector(inBackground:NSSelectorFromString("suspend"),
                                                 with: nil)
        }
    }
}
