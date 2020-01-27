//
//  PluginManagerProtocol.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/24/20.
//

import Foundation

public typealias PluginManagerCompletion = () -> Void

protocol PluginManagerProtocol {
    associatedtype pluginTypeProtocol

    var providers: [pluginTypeProtocol] { get set }

    func prepareManager(completion: PluginManagerCompletion)
    var pluginProtocol: pluginTypeProtocol.Type { get }
}
