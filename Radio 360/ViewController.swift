//
//  ViewController.swift
//  Radio 360
//
//  Created by Hadi Ali on 20/06/2021.
//

import UIKit
import AVKit
import MediaPlayer
import SafariServices
import SideMenu

class ViewController: UIViewController {
    
    @IBOutlet weak var playingButton: UIButton!
    @IBOutlet weak var songLabel: SpringLabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var headerLabel: SpringLabel!
    @IBOutlet weak var airPlayView: UIView!
    @IBOutlet weak var backgroundImgView: UIImageView!
    @IBOutlet weak var imgPlayButton: UIImageView!
    @IBOutlet weak var imgStopButton: UIImageView!
    
    var nowPlayingImageView: UIImageView!
    
    var radioPlayer = FRadioPlayer.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addSideMenu()
        backgroundImgView.image = UIImage(named: "Background-5")
        headerLabel.text = "HeaderLabel".localized
        headerLabel.animation = "flash"
        headerLabel.animate()
        
        // Create Now Playing BarItem
        createNowPlayingAnimation()
        
        // Activate audioSession
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("audioSession could not be activated")
        }
        
        radioPlayer.delegate = self
        radioPlayer.radioURL = URL(string: Constants.streamURL)
        
        // Setup Remote Command Center
        setupRemoteCommandCenter()
        
        // Setup AirPlayButton
        setupAirPlayButton()
        
    }
    
    @IBAction func didTapPlay(_ sender: Any) {
        radioPlayer.togglePlaying()
    }
    
    @IBAction func didTapStop(_ sender: Any) {
        radioPlayer.stop()
    }
    
    @IBAction func didTapFacebook(_ sender: Any) {
        openURL(link: Constants.facebookHook)
    }
    
    @IBAction func didTapInstagram(_ sender: Any) {
        openURL(link: Constants.instagramHooks)
    }
    
    @IBAction func didTapRadioWeb(_ sender: Any) {
        openSafari(link: Constants.website)
    }
    
    @IBAction func didTapYoutube(_ sender: Any) {
        openURL(link: Constants.youtubeHook)
    }
    
    @IBAction func didTapTwitter(_ sender: Any) {
        openURL(link: Constants.twitter)
    }
    
    private func openURL(link: String) {
        if let url = URL(string: link) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                openSafari(link: link)
            }
        }
    }
    
    private func openSafari(link: String) {
        let url = URL(string: link)
        let svc = SFSafariViewController(url: url!)
        svc.dismissButtonStyle = .done
        self.present(svc, animated: true, completion: nil)
    }
    
    private func isPlayingDidChange(_ isPlaying: Bool) {
        imgPlayButton.image = isPlaying ? UIImage(named: "btn-pause") : UIImage(named: "btn-play")
//        playingButton.isSelected = isPlaying
        startNowPlayingAnimation(isPlaying)
    }
}

extension ViewController: FRadioPlayerDelegate {
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        playerStateDidChange(state, animate: true)
    }
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        playbackStateDidChange(state, animate: true)
    }
}

// Helper Functions
extension ViewController {
    
    func addSideMenu() {
        let menuBtn = UIBarButtonItem(image: UIImage(named: "icon-hamburger"), style: .done, target: self, action: #selector(self.openMenu))
        
        self.navigationItem.leftBarButtonItem = menuBtn
    }
    
    @objc func openMenu() {
        self.view.endEditing(true)
        
        let leftRootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
        leftRootVC.delegate = self
        
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: leftRootVC)
        leftMenuNavigationController.setNavigationBarHidden(true, animated: false)
        var setting = SideMenuSettings()
        setting.menuWidth = self.view.bounds.width * 0.45
        leftMenuNavigationController.settings = setting
        leftMenuNavigationController.leftSide = true
        leftMenuNavigationController.presentationStyle = .menuSlideIn
        leftMenuNavigationController.isNavigationBarHidden = false
        leftMenuNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.present(leftMenuNavigationController, animated: true, completion: nil)
    }
    
    func playbackStateDidChange(_ playbackState: FRadioPlaybackState, animate: Bool) {
        
        let message: String?
        
        switch playbackState {
        case .paused:
            message = "PauseMessage".localized
        case .playing:
            message = nil
        case .stopped:
            message = "StopMessage".localized
        }
        
        updateLabels(with: message, animate: animate)
        isPlayingDidChange(radioPlayer.isPlaying)
    }
    
    func playerStateDidChange(_ state: FRadioPlayerState, animate: Bool) {
        
        let message: String?
        
        switch state {
        case .loading:
            message = "LoadingMessage".localized
        case .urlNotSet:
            message = "URLNotValid".localized
        case .readyToPlay, .loadingFinished:
            playbackStateDidChange(radioPlayer.playbackState, animate: animate)
            return
        case .error:
            message = "ErrorPlayingMessage".localized
        }
        
        updateLabels(with: message, animate: animate)
    }
    
    func updateLabels(with statusMessage: String? = nil, animate: Bool = true) {

        guard let statusMessage = statusMessage else {
            // Radio is (hopefully) streaming properly
            songLabel.text = "PlayingTitle".localized
            artistLabel.text = "RadioName".localized
            shouldAnimateSongLabel(animate)
            return
        }
        
        // There's a an interruption or pause in the audio queue
        
        // Update UI only when it's not aleary updated
        guard songLabel.text != statusMessage else { return }
        
        songLabel.text = statusMessage
        artistLabel.text = "RadioName".localized
    
        if animate {
            songLabel.animation = "flash"
            songLabel.repeatCount = 3
            songLabel.animate()
        }
    }
    
    // Animations
    
    func shouldAnimateSongLabel(_ animate: Bool) {
        // Animate if the Track has album metadata
//        guard animate, currentTrack.title != currentStation.name else { return }
        
        // songLabel animation
        songLabel.animation = "zoomIn"
        songLabel.duration = 1.5
        songLabel.damping = 1
        songLabel.animate()
    }
    
    func createNowPlayingAnimation() {
        
        // Setup ImageView
        nowPlayingImageView = UIImageView(image: UIImage(named: "NowPlayingBars-3"))
        nowPlayingImageView.autoresizingMask = []
        nowPlayingImageView.contentMode = UIView.ContentMode.center
        
        // Create Animation
        nowPlayingImageView.animationImages = AnimationFrames.createFrames()
        nowPlayingImageView.animationDuration = 0.7
        
        // Create Top BarButton
        let barButton = UIButton(type: .custom)
        barButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        barButton.addSubview(nowPlayingImageView)
        nowPlayingImageView.center = barButton.center
        
        let barItem = UIBarButtonItem(customView: barButton)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    func startNowPlayingAnimation(_ animate: Bool) {
        animate ? nowPlayingImageView.startAnimating() : nowPlayingImageView.stopAnimating()
    }
    
    //*****************************************************************
    // MARK: - Remote Command Center Controls
    //*****************************************************************
    
    func setupRemoteCommandCenter() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { event in
            return .success
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { event in
            return .success
        }
        
        commandCenter.nextTrackCommand.isEnabled = false
        // Add handler for Next Command
        commandCenter.nextTrackCommand.addTarget { event in
            return .success
        }
        commandCenter.previousTrackCommand.isEnabled = false
        // Add handler for Previous Command
        commandCenter.previousTrackCommand.addTarget { event in
            return .success
        }
    }
    
    func setupAirPlayButton() {
        guard !hideAirPlayButton else {
            airPlayView.isHidden = true
            return
        }

        if #available(iOS 11.0, *) {
            let airPlayButton = AVRoutePickerView(frame: airPlayView.bounds)
            airPlayButton.activeTintColor = globalTintColor
            airPlayButton.tintColor = .red
            airPlayView.backgroundColor = .clear
            airPlayView.addSubview(airPlayButton)
        } else {
            let airPlayButton = MPVolumeView(frame: airPlayView.bounds)
            airPlayButton.showsVolumeSlider = false
            airPlayView.backgroundColor = .clear
            airPlayView.addSubview(airPlayButton)
        }
    }
}

extension ViewController: MenuViewControllerDelegate {
    func didSelect(_ link: String) {
        openSafari(link: link)
    }
}
