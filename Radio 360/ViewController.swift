//
//  ViewController.swift
//  Radio 360
//
//  Created by Hadi Ali on 20/06/2021.
//

import UIKit
import AVKit
import MediaPlayer

class ViewController: UIViewController {
    
//    var player : AVPlayer!
    
    @IBOutlet weak var playingButton: UIButton!
    @IBOutlet weak var songLabel: SpringLabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var airPlayView: UIView!
    
    var nowPlayingImageView: UIImageView!
    
    var radioPlayer = FRadioPlayer.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

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
    
    private func isPlayingDidChange(_ isPlaying: Bool) {
        playingButton.isSelected = isPlaying
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
    
    func playbackStateDidChange(_ playbackState: FRadioPlaybackState, animate: Bool) {
        
        let message: String?
        
        switch playbackState {
        case .paused:
            message = "Station Paused..."
        case .playing:
            message = nil
        case .stopped:
            message = "Station Stopped..."
        }
        
        updateLabels(with: message, animate: animate)
        isPlayingDidChange(radioPlayer.isPlaying)
    }
    
    func playerStateDidChange(_ state: FRadioPlayerState, animate: Bool) {
        
        let message: String?
        
        switch state {
        case .loading:
            message = "Loading Station ..."
        case .urlNotSet:
            message = "Station URL not valide"
        case .readyToPlay, .loadingFinished:
            playbackStateDidChange(radioPlayer.playbackState, animate: animate)
            return
        case .error:
            message = "Error Playing"
        }
        
        updateLabels(with: message, animate: animate)
    }
    
    func updateLabels(with statusMessage: String? = nil, animate: Bool = true) {

        guard let statusMessage = statusMessage else {
            // Radio is (hopefully) streaming properly
            songLabel.text = "Radio 360"
            artistLabel.text = "Radio 360 FM"
            shouldAnimateSongLabel(animate)
            return
        }
        
        // There's a an interruption or pause in the audio queue
        
        // Update UI only when it's not aleary updated
        guard songLabel.text != statusMessage else { return }
        
        songLabel.text = statusMessage
        artistLabel.text = "Radio 360 FM 2"
    
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
// AirPlayButton Color
let globalTintColor = UIColor(red: 0, green: 189/255, blue: 233/255, alpha: 1);

// Set this to "true" to hide the AirPlay button
let hideAirPlayButton = false
