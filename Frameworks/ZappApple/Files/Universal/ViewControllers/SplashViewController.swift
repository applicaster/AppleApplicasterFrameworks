//
//  SplashViewController.swift
//  ZappTvOS
//
//  Created by Anton Kononenko on 11/13/18.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

import UIKit
import AVKit
import ZappCore

class SplashViewController: UIViewController {
    typealias LoadingCompletion = () -> Void
    lazy open var playerViewController = AVPlayerViewController()
    private var loadingCompletion:LoadingCompletion?
    
    @IBOutlet open weak var imageView: UIImageView!
    @IBOutlet open weak var loadingView:UIActivityIndicatorView!
    @IBOutlet open weak var playerContainer: UIView!
    
    @IBOutlet var errorLabel:UILabel?
    
    lazy var videoURL:URL? = {
        var retVal:URL?
        let localMoviePath = DataManager.splashVideoPath()
        if let localMoviePath = localMoviePath,
            FileManager.default.fileExists(atPath: localMoviePath),
            String.isNotEmptyOrWhitespace(localMoviePath) {
            retVal = URL(fileURLWithPath: localMoviePath)
        }
        return retVal
    }()
    
    deinit {
        removeVideoObservers()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        view.backgroundColor = UIColor.black
        addSplashImage()
        prepareController()
    }
    
    func startAppLoading(completion:@escaping LoadingCompletion) {
        loadingView?.color = StylesHelper.color(forKey: CoreStylesKeys.loadingSpinnerColor)
        StylesHelper.updateLabel(forKey: CoreStylesKeys.loadingErrorLabel,
                                 label: errorLabel)
        errorLabel?.isHidden = true
        
        loadingView?.stopAnimating()
        loadingCompletion = completion
        
        if let player = playerViewController.player {
            player.play()
        } else {
            loadingView?.startAnimating()
            callLoadingCompletion()
        }
    }
    
    public func prepareController() {
        if let url = videoURL,
            let playerContainer = playerContainer,
            playerContainer.subviews.count == 0 {
            playerViewController.view.backgroundColor = UIColor.clear
            playerViewController.player = AVPlayer(url:url)
            playerViewController.showsPlaybackControls = false
            addChildViewController(childController: playerViewController,
                                   to: playerContainer)
            playerViewController.videoGravity = .resizeAspectFill
            
            addVideoObservers()
        }
    }
    
    func addSplashImage() {
        self.imageView?.image = UIImage(named: AssetsKeys.splashImageKey)
    }
    
    func callLoadingCompletion() {
        loadingCompletion?()
        loadingCompletion = nil
    }
    
    func hideVideoPlayerContainer() {
        playerContainer?.isHidden = true
    }
    
    func addVideoObservers() {
        self.playerViewController.player?.currentItem?.addObserver(self,
                                                                   forKeyPath: "status",
                                                                   options: .new,
                                                                   context: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: self.playerViewController.player?.currentItem)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground(_:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterBackground(_:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let playerItem = object as? AVPlayerItem {
            if playerItem.status == .failed {
                self.playerViewController.view.isHidden = true
                self.playerDidFinishTask()
            }
        }
    }
    
    func removeVideoObservers() {
        self.playerViewController.player?.currentItem?.removeObserver(self,
                                                                      forKeyPath: "status",
                                                                      context: nil)
    }
    
    @objc open func showErrorMessage(_ errorMessage: String) {
        errorLabel?.isHidden = errorMessage.isEmpty ? true : false
        errorLabel?.text = errorMessage
        loadingView?.startAnimating()
    }
    
    open func playerDidFinishTask() {
        if errorLabel == nil || errorLabel?.isHidden == true {
            loadingView?.startAnimating()
        }
        callLoadingCompletion()
    }
}
extension SplashViewController {
    @objc func playerDidFinishPlaying(_ note: Notification) {
        self.playerDidFinishTask()
    }
    
    @objc func willEnterForeground(_ notification:Notification) {
        self.playerViewController.player?.play()
    }
    
    @objc func didEnterBackground(_ notification:Notification) {
        if self.playerViewController.player?.isPlaying == true {
            self.playerViewController.player?.pause()
        }
    }
}

extension AVPlayer {
    
    var isPlaying: Bool {
        return ((rate != 0) && (error == nil))
    }
}

