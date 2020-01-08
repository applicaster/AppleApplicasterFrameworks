//
//  ReachabilityManager.swift
//  ZappApple
//
//  Created by Anton Kononenko on 6/10/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityManager {
    let reachability = Reachability()!
    var delegate:ReachabilityManagerDelegate
    init(delegate:ReachabilityManagerDelegate) {
        self.delegate = delegate
        startObserve()
    }
    
    func startObserve() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(note:)),
                                               name: .reachabilityChanged,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    func stopObserve() {
        reachability.stopNotifier()

        NotificationCenter.default.removeObserver(self,
                                                  name: .reachabilityChanged,
                                                  object: reachability)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        guard let reachability = note.object as? Reachability else {
            return delegate.reachabilityChanged(connection: .none)
        }
        delegate.reachabilityChanged(connection: reachability.connection)
    }
}
