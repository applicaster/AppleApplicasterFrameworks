//
//  ZPChromecastProtocol.swift
//  ZappCore
//
//  Created by Alex Zchut on 4/12/2020
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public enum ChromecastButtonOrigin:String {
    case appNavbar = "Navbar"
    case playerNavbar = "Fullscreen Player"
    case expendedNavbar = "Chromecast Intermediate Screen"
}

public struct ChromecastIconColorKeys {
    public static let navbar = "chromecast_icon_color"
    public static let player = "player_chromecast_icon_color"
}

public struct ChromecastAnalyticsParams {
    public static let playable = "playableAnalyticsParams"
    public static let customPlayable = "customPlayableAnalyticsParams"
}

public struct ChromecastButtonIcons {
    public static let active = "chromecast_custom_icon_active"
    public static let inactive = "chromecast_custom_icon_inactive"
    public static let animation = "chromecast_custom_icon_animation"
}

public let kChromecastButtonTag = [ChromecastIconColorKeys.navbar: 0,
                                   ChromecastIconColorKeys.player: 1]


public protocol ChromecastProtocol {
    var lastActiveChromecastButton: ChromecastButtonOrigin? {get set}
    var triggerdChromecastButton: ChromecastButtonOrigin? {get set}
    var containerViewEventsDelegate: Any? {get set}
    
    func prepareChromecastForUse() -> Bool
    func hasConnectedCastSession() -> Bool
    func createChromecastButton(frame:CGRect, customIcons: [String: [UIImage]]?) -> UIButton
    func createChromecastButton(frame:CGRect) -> UIButton
    func presentCastInstructionsViewControllerOnce(with castButton:UIButton)
    func defaultExpandedMediaControlsViewController() -> UIViewController?
    func getShouldPresentIntroductionScreen() -> Bool
    func hasAvailableChromecastDevices() -> Bool
}
