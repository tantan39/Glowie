//
//  ViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import AVFoundation

class ViewController: BaseViewController {

    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: AlbumCollectionViewLayout())
        collectionView.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier())
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    let button: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Open", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let playerLayerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .lightGray
        return view
    }()
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .veryLightPinkTwo
        
//        view.addSubview(collectionView)
//        collectionView.snp.makeConstraints { (maker) in
//            maker.edges.equalToSuperview()
//        }
//
//        collectionView.dataSource = self
//
//        view.addSubview(self.playerLayerView)
//        self.playerLayerView.snp.makeConstraints { (maker) in
//            maker.top.left.right.equalToSuperview()
//            maker.height.equalTo(self.view.width * (9/16))
//        }
//
//        view.addSubview(button)
//        button.snp.makeConstraints { (maker) in
//            maker.center.equalToSuperview()
//            maker.width.height.equalTo(60)
//        }
        
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.openFileFolder()
//            if self.isPlaying {
//                self.audioPlayer?.pause()
//            } else {
//                self.playAudio()
//            }
//            self.isPlaying = !self.isPlaying
//            self.playVideo()
        }).disposed(by: self.disposeBag)
        
    }
    let controller = UIDocumentPickerViewController(
        documentTypes: ["public.mpeg-4-audio", "public.mpeg-4", "public.audio", "public.movie", "public.movie"], // choose your desired documents the user is allowed to select
        in: .import // choose your desired UIDocumentPickerMode
    )

    func openFileFolder() {
        controller.delegate = self
        if #available(iOS 11.0, *) {
            controller.allowsMultipleSelection = false
        }
        present(
            controller,
            animated: true,
            completion: nil
        )
    }
    
    var mediaManager: MediaManager?
    
    func playAudio() {
        if let player = self.mediaManager {
            player.play()
        } else {
            let url = "https://aredir.nixcdn.com/NhacCuaTui117/LongHotSummer-KeithUrban_t3zw.mp3"
            mediaManager = MediaManager(url: url)
            mediaManager?.play()
        }
        guard let player = mediaManager else { return }
        player.durationDidChange = { (timer, duration) in
            logDebug("timer \( timer.seconds) --- duration \(duration)")
        }
    }
    
    func playVideo() {
        let url = "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
        self.mediaManager = MediaManager(url: url, type: .video, playerContainer: self.playerLayerView)
        
        self.mediaManager?.play()
        
        guard let player = mediaManager else { return }
        player.durationDidChange = { (timer, duration) in
            logDebug("timer \( timer.seconds) --- duration \(duration)")
        }
    }
}

extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier(), for: indexPath) as? ThumbnailCollectionViewCell

        return cell ?? UICollectionViewCell()
    }
}
