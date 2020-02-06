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

public class RootViewController: UIViewController {
    @IBOutlet var userInterfaceLayerContainerView: UIView!
    @IBOutlet var splashScreenContainerView: UIView!

    public var appDelegate: AppDelegateProtocol?
    public var appReadyForUse: Bool = false

    var reachabilityManger: ReachabilityManager?
    var currentConnection: Reachability.Connection?

    var loadingStateMachine: LoadingStateMachine!
    public var userInterfaceLayer: UserInterfaceLayerProtocol?
    public var pluginsManager = PluginsManager()
    lazy public var identityClient: IdentityClient = {
        let bucketId = SessionStorage.sharedInstance.get(key: ZappStorageKeys.bucketId,
                                                         namespace: nil)
        return IdentityClient(bucketID: bucketId!)
    }()

    var splashViewController: SplashViewController? {
        return children.first { ($0 as? SplashViewController) != nil } as? SplashViewController
    }

    public lazy var facadeConnector: FacadeConnector = {
        FacadeConnector(connectorProvider: self)
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        if let userInterfaceLayer = UserInterfaceLayerManager.layerAdapter(launchOptions: appDelegate?.launchOptions) {
            self.userInterfaceLayer = userInterfaceLayer
        }

        view.backgroundColor = StylesHelper.color(forKey: CoreStylesKeys.backgroundColor)
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

        let identityClient = LoadingState()
        identityClient.stateHandler = loadAISGroup
        identityClient.readableName = "Load Identety Client"

        // Dependant states
        let userInterfaceLayer = LoadingState()
        userInterfaceLayer.stateHandler = loadUserInterfaceLayerGroup
        userInterfaceLayer.readableName = "Prepare User Interface Layer"
        return [splashState,
                plugins,
                styles,
                identityClient,
                userInterfaceLayer]
    }
    
    
}
