//
//  ZPChromecastProtocol.swift
//  ZappCore
//
//  Created by Alex Zchut on 4/12/2020
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public protocol ChromecastExtendedPlayerControlsProtocol: ChromecastProtocol {
    func play(playableItems: NSArray,  playPosition: TimeInterval)
    func extendedPlayerControlsOrientationMask() -> UIInterfaceOrientationMask
    func getExpandedPlayerControlsViewController() -> UIViewController
    func getInlinePlayerControlsViewController() -> UIViewController
    func getMiniPlayerControlsViewController() -> UIViewController?
    func presentExtendedPlayerControls()
    func canShowPlayerBeforeCastSync() -> Bool
}
