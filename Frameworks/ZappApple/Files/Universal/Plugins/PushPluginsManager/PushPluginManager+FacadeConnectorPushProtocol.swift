//
//  PushPluginManager+FacadeConnectorPushProtocol.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/27/20.
//

import Foundation
import ZappCore

extension PushPluginsManager: FacadeConnectorPushProtocol {
    @objc func addTagsToDevice(_ tags: [String]?,
                               completion: @escaping (_ success: Bool, _ tags: [String]?) -> Void) {
        //TODO:
    }

    @objc func removeTagsToDevice(_ tags: [String]?,
                                  completion: @escaping (_ success: Bool, _ tags: [String]?) -> Void) {
        //TODO:
    }

    @objc func getDeviceTags() -> [String:[String]] {
        var retVal: [String:[String]] = [:]
        _providers.forEach { providerDict in
            let provider = providerDict.value
            if let deviceTags = provider.getDeviceTags?(),
                let pluginIdentifier = provider.model?.identifier {
                retVal[pluginIdentifier] = deviceTags
            }
        }
        return  retVal
    }
}
