//
//  FacadeConnectorStorageProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 10/8/19.
//  Copyright © 2019 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol FacadeConnectorPluginManagerProtocol {
    @objc func plugin(for identifier: String) -> ZPPluginModel?
    @objc func getAllPlugins() -> [ZPPluginModel]?
    @objc func adapterClass(_ pluginModel: ZPPluginModel) -> AnyClass?
}
