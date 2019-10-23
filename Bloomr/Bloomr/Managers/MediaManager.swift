//
//  AudioManager.swift
//  Bloomr
//
//  Created by Tan Tan on 8/29/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import AVFoundation
enum MediaType {
    case audio
    case video
}

class MediaManager: NSObject {
    private var url: URL?
    private var playerItem: AVPlayerItem?
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var mediaType: MediaType?

    lazy var isPlaying: Bool = {
        return self.player?.rate != 0 && self.player?.error == nil 
    }()
    
    lazy var duration: Double = {
        return self.playerItem?.asset.duration.seconds ?? 0.0
    }()
    
    var durationDidChange: ((_ timer: CMTime, _ totalDuration: Double) -> Void)?
    var observer: NSKeyValueObservation?
    
    init(url: String?, type: MediaType? = nil, playerContainer: UIView? = nil) {
        super.init()
        guard let stringURL = url, let url = URL(string: stringURL) else { return }
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        self.url = url
        self.playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: self.playerItem)
        if type == .video {
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer?.frame = playerContainer?.frame ?? .zero
            playerContainer?.layer.addSublayer(self.playerLayer!)
        }
        
        self.handleObserver()
    }
    
    private func handleObserver() {
        self.player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: DispatchQueue.main, using: { (timer) in
            self.durationDidChange?(timer, self.duration)
        })
        
        self.observer?.invalidate()
        self.observer = self.playerItem?.observe(\.status, options: [.new, .old], changeHandler: { (playItem, _) in
            switch playItem.status {
            case .readyToPlay:
                break
            case .failed, .unknown:
                logDebug("failed \(playItem.error?.localizedDescription ?? "")")
            default:
                break
            }
        })

    }
    
    func play() {
        self.player?.play()
    }
    
    func pause() {
        self.player?.pause()
    }
    
    deinit {
        self.observer?.invalidate()
    }
    
    func enableSpeaker(_ enable: Bool) {
        let session = AVAudioSession.sharedInstance()
          var _: Error?
        try? session.setCategory(AVAudioSession.Category.playAndRecord)
        try? session.setMode(AVAudioSession.Mode.voiceChat)
          if enable {
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
          } else {
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
          }
          try? session.setActive(true)
    }
}
