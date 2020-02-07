//
//  RootViewController.swift
//  ZappApple
//
//  Created by Anton Kononenko on 11/13/18.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

import Reachability
import UIKit
import ZappCore

public class RootController: NSObject {
    @IBOutlet var userInterfaceLayerContainerView: UIView!
    @IBOutlet var splashScreenContainerView: UIView!

    public var appDelegate: AppDelegateProtocol?
    public var appReadyForUse: Bool = false

    var reachabilityManger: ReachabilityManager?
    var currentConnection: Reachability.Connection?

    var loadingStateMachine: LoadingStateMachine!
    public var userInterfaceLayer: UserInterfaceLayerProtocol?
    public var pluginsManager = PluginsManager()

    lazy var splashViewController: SplashViewController? = {
        return nil // Should retrieved from story board or similar implamentation
//        return children.first { ($0 as? SplashViewController) != nil } as? SplashViewController
    }()

    public lazy var facadeConnector: FacadeConnector = {
        FacadeConnector(connectorProvider: self)
    }()

    public override init() {
        super.init()
        if let userInterfaceLayer = UserInterfaceLayerManager.layerAdapter(launchOptions: appDelegate?.launchOptions) {
            self.userInterfaceLayer = userInterfaceLayer
        }

        reachabilityManger = ReachabilityManager(delegate: self)

        reloadApplication()
    }

    func reloadApplication() {
        appReadyForUse = false
        loadingStateMachine = LoadingStateMachine(dataSource: self,
                                                  withStates: preapreLoadingStates())
        loadingStateMachine.startStatesInvocation()
    }

    func preapreLoadingStates() -> [LoadingState] {
        let splashState = LoadingState()
        splashState.stateHandler = loadApplicationLoadingGroup
        splashState.readableName = "Show Splash Screen"

        let plugins = LoadingState()
        plugins.stateHandler = loadPluginsGroup
        plugins.readableName = "Load plugins"

        let styles = LoadingState()
        styles.stateHandler = loadStylesGroup
        styles.readableName = "Load Styles"

        // Dependant states
        let userInterfaceLayer = LoadingState()
        userInterfaceLayer.stateHandler = loadUserInterfaceLayerGroup
        userInterfaceLayer.readableName = "Prepare User Interface Layer"
        return [splashState,
                plugins,
                styles,
                userInterfaceLayer]
    }
    
    
}
