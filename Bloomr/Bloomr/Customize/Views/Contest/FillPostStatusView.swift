//
//  FillPostStatusView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/28/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import Photos
class FillPostStatusView: BaseView {
    let dimView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        return view
    }()
    
    let updateStatusView: UpdatePostStatusView = {
        let view = UpdatePostStatusView(frame: .zero)
        return view
    }()
    
    let bottomStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.backgroundColor = .white
        stackView.isHidden = true
        return stackView
    }()
    
    private let titleView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Thêm màu cho bản audio của bạn nào".localized()
        label.textColor = .brown_grey
        label.font = UIFont.fromType(.primary(.regular, .h3))
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(AudioBackgroundCell.self, forCellWithReuseIdentifier: AudioBackgroundCell.cellIdentifier())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var isShow: Bool = false {
        didSet {
            self.isHidden = !isShow
        }
    }
    
    var datasource: [UIImage]?
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupDimView()
        setupUpdateStatusView()
        setupBottomStackView()
        setupTitleView()
        setupTitleLabel()
        setupCollectionView()
    }
    
    private func setupDimView() {
        self.addSubview(dimView)
        self.dimView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        self.dimView.addTapGestureRecognizer {
            self.isShow = false
            self.endEditing(true)
        }
    }
    
    private func setupUpdateStatusView() {
        self.dimView.addSubview(self.updateStatusView)
        self.dimView.bringSubviewToFront(self.updateStatusView)
        self.updateStatusView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
            let estimateHeight = (Dimension.shared.widthScreen/3) + (Dimension.shared.mediumVerticalMargin * 2)
            maker.height.equalTo(estimateHeight)
        }
    }
    
    private func setupBottomStackView() {
        self.dimView.addSubview(self.bottomStackView)
        self.dimView.bringSubviewToFront(self.bottomStackView)
        self.bottomStackView.snp.makeConstraints { (maker) in
            maker.bottom.leading.trailing.equalToSuperview()
            maker.height.equalTo(115)
        }
    }
    
    private func setupTitleView() {
        self.bottomStackView.addArrangedSubview(self.titleView)
        self.titleView.snp.makeConstraints { (maker) in
            maker.height.equalTo(30)
        }
    }
    
    private func setupTitleLabel() {
        self.titleView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.centerY.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        self.bottomStackView.addArrangedSubview(self.collectionView)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 60, height: 60)
            layout.minimumLineSpacing = Dimension.shared.mediumHorizontalMargin
        }
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Dimension.shared.normalVerticalMargin, bottom: 0, right: 0)
        self.collectionView.dataSource = self
    }
}

extension FillPostStatusView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AudioBackgroundCell.cellIdentifier(), for: indexPath) as? AudioBackgroundCell, let image = self.datasource?[indexPath.row] else { return UICollectionViewCell() }
        cell.imageView.image = image
        return cell
    }
}

extension FillPostStatusView {
    func setThumbnail(_ asset: PHAsset, caption: String?) {
        self.updateStatusView.thumbnailImageView.image = asset.getAssetThumbnail(size: CGSize(width: Dimension.shared.widthScreen/3, height: Dimension.shared.heightScreen/3))
        self.updateStatusView.textView.text = caption
        if asset.mediaType == .video {
            self.updateStatusView.durationLabel.isHidden = false
            self.updateStatusView.durationLabel.text = asset.duration.durationString()
        } else {
            self.updateStatusView.durationLabel.isHidden = true
        }
    }
    
    func setAudioContent(_ image: UIImage, caption: String?, title: String?, duration: String?) {
        self.updateStatusView.thumbnailImageView.image = image
        self.updateStatusView.textView.text = caption
        self.updateStatusView.configAudio(title: title, duration: duration)
    }
}
