//
//  PluginManagerProtocol.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/24/20.
//

import Foundation
import ZappCore

public typealias PluginManagerCompletion = ((_ success:Bool) -> Void)?

protocol PluginManagerProtocol {
    associatedtype pluginTypeProtocol
    var pluginType: ZPPluginType { get }
    var pluginProtocol: pluginTypeProtocol.Type { get }

    var providers: [String: pluginTypeProtocol] { get set }

    func prepareManager(completion: PluginManagerCompletion)
}
