//
//  PostContentViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/24/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Pulley
class PostContentViewController: BaseViewController, GiveFlowerAble {
    var droppableLocations: [SEDraggableLocation]? = []
    
    let topPadding: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: Dimension.shared.smallVerticalMargin, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 5
        layout.estimatedItemSize = CGSize(width: self.view.width, height: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = false
        collectionView.register(CommentStatusCollectionViewCell.self, forCellWithReuseIdentifier: CommentStatusCollectionViewCell.cellIdentifier())
        collectionView.register(StatusHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StatusHeaderView.reuseIdentifier())
        return collectionView
    }()
    
    private lazy var inputToolbar: CommentToolBarView = {
        let view = CommentToolBarView(frame: .zero)
        view.textView.delegate = self
        return view
    }()
    
    let minHeight: CGFloat = 120.0
    var numberItems = 20
    
    var viewModel: PostShowsViewModel?
    
    convenience init(viewModel: PostShowsViewModel?) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        view.backgroundColor = .white
        setupTopPaddingView()
        
        setutInputToolView()
        setupCollectionView()
        
    }
    
    private func setupTopPaddingView() {
        self.view.addSubview(self.topPadding)
        self.topPadding.snp.makeConstraints { (maker) in
            maker.leading.top.trailing.equalToSuperview()
            maker.height.equalTo(20)
        }
    }
    
    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.topPadding.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(self.inputToolbar.snp.top)
        }
    }
    
    fileprivate func setutInputToolView() {
        self.view.addSubview(inputToolbar)
        inputToolbar.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset( -49 - Dimension.shared.normalVerticalMargin_20)
            } else {
                maker.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-Dimension.shared.smallVerticalMargin)
            }
//                        maker.bottom.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
        }
        
        self.view.addTapGestureRecognizer {
            self.view.endEditing(true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        //        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).subscribe { [weak self] (notif) in
        //            self?.collectionView.scrollToItem(at: IndexPath(row: self?.numberItems ?? 0 - 1, section: 0), at: .bottom, animated: true)
        //        }
    }
    
    private func handleObservers() {
        self.inputToolbar.doneButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.postDetails.subscribe(onNext: { [weak self] (post) in
            guard let self = self, let post = post else { return }
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight -= self.view.safeAreaInsets.bottom
                }
            }
            self.inputToolbar.textView.snp.updateConstraints { (maker) in
                maker.bottom.equalTo(-keyboardHeight)
            }
            self.view.layoutIfNeeded()
            self.inputToolbar.state = keyboardHeight == 0 ? .normal : .active
        }
    }

}

extension PostContentViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == self.inputToolbar.textView {
            _ = DetailStatusRouter().navigate(from: self.navigationController, transitionType: .push, animated: true)
            return false
        }
        return true
    }
}

extension PostContentViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let header = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: section)) as? StatusHeaderView
        let size = CGSize(width: 1000, height: 10)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let text = header?.contentLabel.text
        let estimateFrame = NSString(string: text ?? "").boundingRect(with: size, options: option, attributes: [NSAttributedString.Key.font: UIFont.fromType(.primary(.regular, .h3))], context: nil)
        return CGSize(width: self.view.width, height: estimateFrame.height + Dimension.shared.largeVerticalMargin + Dimension.shared.avatarWidth_38 + Dimension.shared.mediumVerticalMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StatusHeaderView.reuseIdentifier(), for: indexPath) as? StatusHeaderView else { return UICollectionReusableView() }
            if let post = self.viewModel?.postDetails.value {
                view.bindingData(post: post)
            }
            return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentStatusCollectionViewCell.cellIdentifier(), for: indexPath) as? CommentStatusCollectionViewCell else { return UICollectionViewCell() }
        cell.draggableLocation.delegate = self
//        self.droppableLocations?.append(cell.draggableLocation)
        return cell
        
    }
}

extension PostContentViewController: SEDraggableLocationEventResponder {
    func draggableLocation(_ location: SEDraggableLocation!, didAcceptObject object: SEDraggable!, entryMethod method: SEDraggableLocationEntryMethod) {
        AppManager.showExpandingMenu(from: location, style: .cell, homeSelected: {
            
        }, valueSelected: { (index) in
            
        }, storeSelected: {
            
        })
    }
}

extension PostContentViewController: PulleyDrawerViewControllerDelegate {
    func supportedDrawerPositions() -> [PulleyPosition] {
        return [.collapsed, .open]
    }
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return minHeight
    }
}
