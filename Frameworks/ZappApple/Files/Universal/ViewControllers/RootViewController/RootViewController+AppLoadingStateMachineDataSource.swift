//
//  RootViewController+StateMachine.swift
//  ZappApple
//
//  Created by Anton Kononenko on 11/14/18.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

import Foundation
import os.log
import ZappCore

public let kMSAppCenterCheckForUpdatesNotification = "kMSAppCenterCheckForUpdatesNotification"

extension RootViewController: LoadingStateMachineDataSource {
    func loadApplicationLoadingGroup(_ successHandler: @escaping StateCallBack,
                                     _ failHandler: @escaping StateCallBack) {
        splashViewController?.startAppLoading(completion: {
            successHandler()
        })
    }

    func loadPluginsGroup(_ successHandler: @escaping StateCallBack,
                          _ failHandler: @escaping StateCallBack) {
        pluginsManager.intializePlugins { success in
            if success == true {
                self.spotLightSubscription.activate()
                successHandler()
            } else {
                failHandler()
            }
        }
    }

    func loadStylesGroup(_ successHandler: @escaping StateCallBack,
                         _ failHandler: @escaping StateCallBack) {
        let loadingManager = LoadingManager()
        loadingManager.loadFile(type: .styles) { success in
            if success == true {
                successHandler()
                StylesHelper.updateZappStyles()
            } else {
                failHandler()
            }
        }
    }

    func loadUserInterfaceLayerGroup(_ successHandler: @escaping StateCallBack,
                                     _ failHandler: @escaping StateCallBack) {
        guard let userInterfaceLayer = userInterfaceLayer else {
            failHandler()
            return
        }
        userInterfaceLayer.prepareLayerForUse { [weak self] quickBrickViewController, error in
            if let quickBrickViewController = quickBrickViewController {
                self?.userInterfaceLayerContainerView.subviews.forEach { $0.removeFromSuperview() }
                self?.userInterfaceLayerContainerView.addSubview(quickBrickViewController.view)
                quickBrickViewController.view.matchParent()
                successHandler()
            } else if let error = error {
                _ = OSLog(subsystem: error.localizedDescription,
                          category: stateMachineLogCategory)
                failHandler()
            }
        }
    }

    public func stateMachineFinishedWork(with state: LoadingStateTypes) {
        if state == .success {
            appReadyForUse = true
            userInterfaceLayerContainerView.isHidden = false
            splashScreenContainerView.isHidden = true

            facadeConnector.analytics?.sendEvent?(name: CoreAnalyticsKeys.applicationWasLaunched,
                                                  parameters: [:])
            appDelegate?.handleDelayedUrlSchemeCallIfNeeded()

            NotificationCenter.default.post(name: Notification.Name(kMSAppCenterCheckForUpdatesNotification),
                                            object: nil)
        } else {
            userInterfaceLayerContainerView.isHidden = true
            splashScreenContainerView.isHidden = false

            // TODO: After will be added multi language support should be take from localization string
            splashViewController?.showErrorMessage("Loading failed. Please try again later")
        }
    }

    func loadAISGroup(_ successHandler: @escaping StateCallBack,
                      _ failHandler: @escaping StateCallBack) {
        identityClient.createDevice { success, _ in
            if success {
                successHandler()
            } else {
                failHandler()
            }
        }
    }
}
