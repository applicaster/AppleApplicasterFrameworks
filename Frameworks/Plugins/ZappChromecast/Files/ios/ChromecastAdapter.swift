//
//  ChromecastAdapter.swift
//  ZappChromecast
//
//  Created by Alex Zchut on 4/12/2020
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import GoogleCast
import ZappCore

open class ChromecastAdapter: NSObject {
    public var configurationJSON: NSDictionary?
    public var model: ZPPluginModel?
    public var enabled: Bool = false
    public var initialized: Bool = false
    
    public required init(pluginModel: ZPPluginModel) {
        model = pluginModel
        configurationJSON = model?.configurationJSON
    }
    
    /// Plugin configuration keys
    struct PluginKeys {
        static let applicationID = "app_id"
        static let posterUrl = "poster_url"
        static let showMiniControls = "show_mini_controls"
    }

    var chromecastAppId:String? {
        guard let value = configurationJSON?[PluginKeys.applicationID] as? String,
            value.isEmpty == false else {
                return nil
        }
        return value
    }
    
    var pluginPosterURL:String? {
        guard let value = configurationJSON?[PluginKeys.posterUrl] as? String,
            value.isEmpty == false else {
                return nil
        }
        return value
    }
    
    var shouldShowMiniControls: Bool {
        var show = false
        if let stringValue = configurationJSON?[PluginKeys.showMiniControls] as? String {
            if let boolValue = Bool(stringValue) {
                show = boolValue
            }
            else if let intValue = Int(stringValue) {
                show = Bool(truncating: intValue as NSNumber)
            }
        } else if let boolValue = configurationJSON?[PluginKeys.showMiniControls] as? Bool {
            show = boolValue
        }
        
        return show
    }
    
    lazy var castViewExtender: ChromecastCustomDialogProtocol? = {
        var retVal:ChromecastCustomDialogProtocol?

//        let pluginModels = ZPPluginManager.pluginModels()?.filter { $0.pluginType == .General}
//
//        if let pluginModels = pluginModels {
//            for pluginModel in pluginModels {
//                if let classType = ZPPluginManager.adapterClass(pluginModel) as? ChromecastCustomDialogProtocol.Type,
//                    let provider = classType.init() as? (ChromecastCustomDialogProtocol) {
//                    retVal = provider
//                }
//            }
//        }
        return retVal
    }()
    
    
    // Where the icon was tapped from that lead to the CastDialog
    var localLastActiveChromecastButton: ChromecastButtonOrigin?

    // What the "Icon Location" was that the tap which lead to the casting came from.
    var localTriggerdChromecastButton: ChromecastButtonOrigin?

    var localContainerViewEventsDelegate: ChromecastNotificationsProtocol? {
        willSet {
            if newValue == nil  {
                self.uninstallMiniPlayerViewController()
            }
        }

        didSet {
            if localContainerViewEventsDelegate != nil  {
                self.updateVisibilityOfMiniPlayerViewController()
            }
        }
    }

    //private  properties
    var castSession:GCKCastSession?
    var castButton: UIButton?
    var connectivityState: ConnectivityState = .cellular {
        didSet {
            updateCastButtonVisibility()
        }
    }
    var noReachabilityStatusPresented: Bool = false
    var shouldPresentIntroductionScreen: Bool = false

    // The media object to play
    var mediaInfo: GCKMediaInformation?

    //public properties
    open var miniMediaControlsViewController: GCKUIMiniMediaControlsViewController?

    deinit {
        // perform the deinitialization
        self.removeObservers()
    }
    
    @objc open func presentIntroductionScreenIfNeeded() {
        if getShouldPresentIntroductionScreen(),
            let castButton = self.castButton {
            presentCastInstructionsViewControllerOnce(with: castButton)
        }
    }
    
    func updateManagerState(enabled: Bool, initialized: Bool) {
        self.initialized = initialized
        self.enabled = enabled
    }
    
    @objc open func addButton(to container: UIView?,
                                 key: String,
                                 color: UIColor?) {
       if enabled {
           guard let container = container else {
               return
           }
           
           //create button with container bounds
           self.createButtonIfNeeded(frame: container.bounds)

           guard let button = castButton else {
               return
           }
           
           // customize button color
           if let buttonColor = color {
               button.tintColor = buttonColor
           }
           
           // set button tag for analytics reasons
           if let tag = kChromecastButtonTag[key] {
               button.tag = tag
           }
           
           //add subview
           container.addSubview(button)

           button.translatesAutoresizingMaskIntoConstraints = false
           let views = ["button": button]
            let metrics: [String: AnyObject] = ["width": container.frame.size.width as AnyObject, "height": container.frame.size.height as AnyObject]
           container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[button(height)]|", options: .alignAllCenterY, metrics: metrics, views: views))
           container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[button(width)]|", options: .alignAllCenterX, metrics: metrics, views: views))

           
           // create mini player
           createMiniPlayerViewController()
        }
    }
    
    fileprivate func createButtonIfNeeded(frame: CGRect) {
        guard castButton == nil else {
            return
        }
        
        let button = createChromecastButton(frame: frame)

        // catch tap event for analytics
        button.addTarget(self, action: #selector(chromecastButtonTapped(_:)), for: .touchUpInside)

        
        // assign cast button
        castButton = button
    }
    
    @objc private func chromecastButtonTapped(_ sender: UIButton?) {
        guard let chromecastButton = sender else {
            return
        }

        switch chromecastButton.tag {
        case 0:
            lastActiveChromecastButton = .appNavbar
        case 1:
            lastActiveChromecastButton = .playerNavbar
        default:
            print("Chromecast button was pressed without a configured tag, please be aware")
        }
    }
}
