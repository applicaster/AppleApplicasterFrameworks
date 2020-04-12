//
//  ChromecastButtonContainer.swift
//  ZappGeneralPluginChromecast
//
//  Created by Alex Zchut on 31/03/2020.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import React

@objc(ChromecastButtonContainer)
class ChromecastButtonContainer: RCTView {
    @objc public var key: String = "chromecast_icon_color"
    @objc public var color: UIColor = .white

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
