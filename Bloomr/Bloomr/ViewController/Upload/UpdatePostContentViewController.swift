//
//  UpdatePostContentViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IQKeyboardManager
import RxCocoa
import RxSwift
import RxKeyboard
import SVProgressHUD
class UpdatePostContentViewController: BaseViewController {
    let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var inputNameView: InputNickNameView = {
        let view = InputNickNameView(frame: .zero)
        view.isHidden = true
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(UpdatePostContentCell.self, forCellWithReuseIdentifier: UpdatePostContentCell.cellIdentifier())
        collectionView.backgroundColor = .light_grey
        collectionView.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    lazy var fillStatusCustomView: FillPostStatusView = {
        let view = FillPostStatusView(frame: .zero)
        view.isShow = false
        view.datasource = self.viewModel?.audioThumbnails
        return view
    }()
    
    var viewModel: UpdatePostContentViewModel?

    convenience init(viewModel: GalleryViewModel?, audioUrl: String? = nil) {
        self.init()
        self.viewModel = UpdatePostContentViewModel(galleryViewModel: viewModel, audioUrl: audioUrl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        
        self.showNavigationBarRightViewStyle(.next)
        self.rightBarButton?.title = "Upload".localized()
        
        handleObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupStackView()
        setupInputNameView()
        setupCollectionView()
        setupFillStatusView()
    }
    
    private func setupStackView() {
        self.view.addSubview(stackView)
        self.stackView.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8)
            }
            maker.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupInputNameView() {
        self.stackView.addArrangedSubview(self.inputNameView)
        self.inputNameView.snp.makeConstraints { (maker) in
            maker.height.equalTo(80)
        }
    }
    
    private func setupCollectionView() {
        self.stackView.addArrangedSubview(self.collectionView)

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0.0
            layout.scrollDirection = .vertical
        }
    }
    
    private func setupFillStatusView() {
        self.view.addSubview(self.fillStatusCustomView)
        self.fillStatusCustomView.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            }
            maker.leading.trailing.bottom.equalToSuperview()
        }
        
        self.fillStatusCustomView.bottomStackView.isHidden = self.viewModel?.contestFormat != .audio
    }
    
    private func handleObservers() {
        self.viewModel?.isLoading.subscribe(onNext: { (loading) in
            if loading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }).disposed(by: self.disposeBag)
        
        self.rightBarButton?.rx.tap.subscribe(onNext: { _ in
            if let _ =  self.viewModel?.audioUrl {
                self.viewModel?.uploadAudio(completion: { [weak self] (_, error) in
                    guard let self = self else { return }
                    if let error = error {
                        self.handle(error)
                    }
                })
                
            } else {
                self.viewModel?.uploadPhoto(callback: { [weak self] (error) in
                    guard let self = self, let error = error else { return }
                    self.handle(error)
                })
            }
            
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.selectedIndex.subscribe(onNext: { [weak self] (index) in
            guard let self = self, let idx = index, let post = self.viewModel?.posts.value[idx] else { return }
            
            if post.contentType == .audio {
                if let thumbnail = post.thumbnailImage {
                    self.fillStatusCustomView.setAudioContent(thumbnail, caption: post.caption, title: post.title, duration: "")
                }
            } else {
                if let asset = self.viewModel?.assets?[idx] {
                    self.fillStatusCustomView.setThumbnail(asset, caption: post.caption)
                }
            }
            self.fillStatusCustomView.isShow = true
            self.fillStatusCustomView.updateStatusView.textView.becomeFirstResponder()
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.createPostSuccess.subscribe(onNext: { [weak self] (result) in
            guard let self = self, result else { return }
            switch self.viewModel?.contestFormat {
            case .audio:
                self.navigationController?.popViewController(animated: false)
                if let contestRankingVC = UIViewController.topMostViewController() as? ContestRankingViewController {
                    _ = ContestAlbumRouter(contest: AppManager.shared.selectedContest).navigate(from: contestRankingVC.navigationController, transitionType: .push, animated: true)
                }
            default:
                self.dismiss(animated: false, completion: {
                    if let contestRankingVC = UIViewController.topMostViewController() as? ContestRankingViewController {
                        _ = ContestAlbumRouter(contest: AppManager.shared.selectedContest).navigate(from: contestRankingVC.navigationController, transitionType: .push, animated: true)
                    }
                })
            }
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.joinContestSuccess.subscribe(onNext: { [weak self] (joined) in
            guard let self = self, joined else { return }
            switch self.viewModel?.contestFormat {
            case .audio:
                self.navigationController?.popViewController(animated: false)
                if let contestRankingVC = UIViewController.topMostViewController() as? ContestRankingViewController {
                    _ = ContestAlbumRouter(contest: AppManager.shared.selectedContest).navigate(from: contestRankingVC.navigationController, transitionType: .push, animated: true)
                }
            default:
                self.dismiss(animated: false, completion: {
                    if let contestRankingVC = UIViewController.topMostViewController() as? ContestRankingViewController {
                        _ = ContestAlbumRouter(contest: AppManager.shared.selectedContest).navigate(from: contestRankingVC.navigationController, transitionType: .push, animated: true)
                    }
                })
            }
        }).disposed(by: self.disposeBag)
        
        self.fillStatusCustomView.updateStatusView.textView.rx.text.subscribe(onNext: { (text) in
            guard let text = text, let index = self.viewModel?.selectedIndex.value, let post = self.viewModel?.posts.value[index] else { return }
            post.caption = text
            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }).disposed(by: self.disposeBag)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight -= self.view.safeAreaInsets.bottom
                }
            }
            self.fillStatusCustomView.snp.updateConstraints { (maker) in
                maker.bottom.equalTo(-keyboardHeight-40)
            }
            self.view.layoutIfNeeded()
        }
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension UpdatePostContentViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Top padding + thumnail imageview height + bottom padding
        let estimateHeight = (self.view.width/3) + (Dimension.shared.mediumVerticalMargin * 2)
        return CGSize(width: self.view.width, height: estimateHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        self.viewModel?.posts.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpdatePostContentCell.cellIdentifier(), for: indexPath) as? UpdatePostContentCell, let post = self.viewModel?.posts.value[indexPath.row], let thumbnail = post.thumbnailImage else { return UICollectionViewCell() }
        
        switch self.viewModel?.contestFormat {
        case .audio:
            cell.setAudioContent(thumbnail, caption: post.caption, title: post.title, duration: "1:20")
        case .photo:
            cell.setThumbnail(thumbnail, caption: post.caption)
        case .video:
            let asset = self.viewModel?.assets?[indexPath.row]
            cell.setVideoContent(thumbnail, caption: post.caption, duration: asset?.duration.durationString())
        default:
            break
        }

        cell.delegate = self
        return cell
    }
}

extension UpdatePostContentViewController: UpdatePostContentCellDelegate {
    func statusTextView_DidPressed(_ cell: UpdatePostContentCell?) {
        guard let cell = cell, let indexPath = self.collectionView.indexPath(for: cell) else { return }
        self.viewModel?.selectedIndex.accept(indexPath.row)
    }
}
