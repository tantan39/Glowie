//
//  DetailStatusViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/22/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxSwift
import RxCocoa
class DetailStatusViewController: BaseViewController {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.estimatedItemSize = CGSize(width: self.view.width, height: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(CommentStatusCollectionViewCell.self, forCellWithReuseIdentifier: CommentStatusCollectionViewCell.cellIdentifier())
        collectionView.register(StatusHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StatusHeaderView.reuseIdentifier())
        return collectionView
    }()

    private let inputToolbar: CommentToolBarView = {
        let view = CommentToolBarView(frame: .zero)
        return view
    }()
    
    var numberItems = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func setupUIComponents() {
        super.setupUIComponents()
        view.backgroundColor = .white
        
        setutInputToolView()
        setupCollectionView()
    
    }
    
    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(self.inputToolbar.snp.top)
        }
    }
    
    fileprivate func setutInputToolView() {
        self.view.addSubview(inputToolbar)
        inputToolbar.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-Dimension.shared.smallVerticalMargin)
            } else {
                maker.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-Dimension.shared.smallVerticalMargin)
            }
//            maker.bottom.equalToSuperview()
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

extension DetailStatusViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
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
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StatusHeaderView.reuseIdentifier(), for: indexPath)
            return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentStatusCollectionViewCell.cellIdentifier(), for: indexPath) as? CommentStatusCollectionViewCell
        cell?.draggableLocation.delegate = self
        return cell ?? UICollectionViewCell()

    }
}

extension DetailStatusViewController: SEDraggableLocationEventResponder {
    func draggableLocation(_ location: SEDraggableLocation!, didAcceptObject object: SEDraggable!, entryMethod method: SEDraggableLocationEntryMethod) {
        AppManager.showExpandingMenu(from: location, style: .cell, homeSelected: {
            
        }, valueSelected: { (index) in
            
        }, storeSelected: {
            
        })
    }
}
