//
//  ChromecastButtonContainer.swift
//  ZappGeneralPluginChromecast
//
//  Created by Alex Zchut on 31/03/2020.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import React
import ZappCore

@objc public class ChromecastButtonContainer: RCTView {
    @objc public var originKey: NSString?
    @objc public var colorKey: NSString?

    fileprivate let pluginIdentifier = "chromecast_qb"
    var key: String {
        guard let key = originKey else {
            return "chromecast_icon_color"
        }
        return key as String
    }
    
    var color: UIColor {
        guard let colorString = colorKey,
            let color = UIColor(hexColor: colorString as String) else {
            return UIColor.white
        }
        return color
    }
    
    public init(eventDispatcher: RCTEventDispatcher) {
        super.init(frame: .zero)
        
        addChromecastButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addChromecastButton() {
        guard let chromecastPlugin = FacadeConnector.connector?.pluginManager?.getProviderInstance(identifier: pluginIdentifier) as? ChromecastAdapter else {
            return
        }
        
        chromecastPlugin.addButton(to: self,
                                   key: self.key,
                                   color: self.color)
    }
}
