//
//  UrlSchemeHandler+generateNewUUID.swift
//  ZappApple
//
//  Created by Alex Zchut on 26/02/2020.
//

import Foundation
import ZappCore

extension UrlSchemeHandler {
    class func handleUUIDregeneration() -> Bool {
        let title = "Do you want to regenerate UUID?"
        let description = "New UUID will replace the old one and the app will be completely reloaded"
        let yesTitle = "Yes"
        let noTitle = "No"

        let alert = UIAlertController(title: title,
                                      message: description,
                                      preferredStyle: .alert)

        let yesButton = UIAlertAction(title: yesTitle,
                                         style: .destructive,
                                         handler: { _ in
                                            UUIDManager.regenerateUUID()
                                            RootController.currentInstance?.reloadApplication()
        })

        let noButton = UIAlertAction(title: noTitle,
                                         style: .default,
                                         handler: { _ in
                                            alert.dismiss(animated: true, completion: {
                                                RootController.currentInstance?.makeInterfaceLayerAsRootViewContoroller()
                                            })
        })

        alert.addAction(yesButton)
        alert.addAction(noButton)

        RootController.currentInstance?.makeSplashAsRootViewContoroller()
        RootController.currentInstance?.splashViewController?.present(alert,
                                                                      animated: true,
                                                                      completion: nil)

        return true
    }
}
