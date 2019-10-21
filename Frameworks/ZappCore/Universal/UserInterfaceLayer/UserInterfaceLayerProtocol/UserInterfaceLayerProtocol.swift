//
//  UserInterfaceLayerProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 9/24/19.
//  Copyright © 2019 Applicaster LTD. All rights reserved.
//

import Foundation

public protocol UserInterfaceLayerProtocol {
    init(launchOptions: [UIApplication.LaunchOptionsKey: Any]?,
         applicationData: [String: Any])
    func prepareLayerForUse(completion: @escaping (_ viewController: UIViewController?,
                                                   _ error: Error?) -> Void)
}
