//
//  ChromecastButtonContainer.swift
//  ZappGeneralPluginChromecast
//
//  Created by Alex Zchut on 31/03/2020.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import React
import ZappCore

@objc public class ChromecastButton: UIView {
    @objc public var origin: NSString? {
        didSet {
            updateButtonOrigin()
        }
    }
    @objc override public var tintColor: UIColor? {
        didSet {
            updateButtonTintColor()
        }
    }

    fileprivate let pluginIdentifier = "chromecast_qb"
    fileprivate let buttonIconColorKey = "chromecast_icon_color"

    public init(eventDispatcher: RCTEventDispatcher) {
        super.init(frame: .zero)
        addButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addButton() {
        guard let chromecastPlugin = FacadeConnector.connector?.pluginManager?.getProviderInstance(identifier: pluginIdentifier) as? ChromecastAdapter else {
            return
        }

        chromecastPlugin.addButton(to: self,
                                   key: buttonIconColorKey,
                                   color: nil)
    }
    
    func updateButtonTintColor() {
        guard let chromecastPlugin = FacadeConnector.connector?.pluginManager?.getProviderInstance(identifier: pluginIdentifier) as? ChromecastAdapter,
            let color = tintColor else {
            return
        }

        chromecastPlugin.castButton?.tintColor = color
    }
    
    func updateButtonOrigin() {
        guard let chromecastPlugin = FacadeConnector.connector?.pluginManager?.getProviderInstance(identifier: pluginIdentifier) as? ChromecastAdapter,
            let origin = origin as String? else {
            return
        }

        chromecastPlugin.localLastActiveChromecastButton = ChromecastButtonOrigin(rawValue: origin)
    }
}
