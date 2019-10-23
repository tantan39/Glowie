//
//  EditAvatarStatusViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/12/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IQKeyboardManager
import SVProgressHUD
class EditAvatarStatusViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EditAvatarStatusCell.self, forCellWithReuseIdentifier: EditAvatarStatusCell.cellIdentifier())
        collectionView.backgroundColor = .light_grey
        collectionView.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    var viewModel: EditAvatarViewModel?
    var cropedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = TextManager.profilePictureText.localized()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.view.backgroundColor = .white
        self.showNavigationBarRightViewStyle(.done)
        
        setupCollectionView()
        handleObservers()
    }
    
    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            if #available (iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8)
            }
            maker.leading.trailing.bottom.equalToSuperview()
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
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
            guard let photo = self.cropedImage else { return }
            self.viewModel?.uploadAvatar(photo, completionBlock: { [weak self] (obj, error) in
                guard let self = self else { return }
                if let error = error {
                    self.handle(error)
                } else {
                    if let myprofileVC = self.navigationController?.viewControllers.first as? MyProfileViewController {
                        myprofileVC.viewModel?.fetchProfile()
                    }
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.joinContestSuccess.subscribe(onNext: { [weak self] (result) in
            guard let self = self, result else { return }
            if let rankingVC = self.navigationController?.viewControllers.first(where: { $0.isKind(of: ContestRankingViewController.self )}) as? ContestRankingViewController {
                rankingVC.viewModel.joinContestSuccess.accept(result)
                
                self.navigationController?.popToViewController(rankingVC, animated: false)
                _ = ContestAlbumRouter(contest: self.viewModel?.contestSelected).navigate(from: rankingVC.navigationController, transitionType: .push, animated: true)
            }
        }).disposed(by: self.disposeBag)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension EditAvatarStatusViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Top padding + thumnail imageview height + bottom padding
        let estimateHeight = (self.view.width/3) + (Dimension.shared.mediumVerticalMargin * 2)
        return CGSize(width: self.view.width, height: estimateHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditAvatarStatusCell.cellIdentifier(), for: indexPath) as? EditAvatarStatusCell/*, let asset = self.viewModel?.galleryViewModel.selectedAssets?[indexPath.row]*/ else { return UICollectionViewCell() }
        cell.setThumbnail(self.cropedImage)
//        cell.delegate = self
        return cell
    }
}
