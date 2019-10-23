//
//  InteractiveUserListViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/15/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class InteractiveUserListViewController: BaseViewController {
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var pageMenuView: InteractivePageMenu = {
        let view = InteractivePageMenu(frame: .zero)
        view.dataSource = ["Givers", "Receivers"]
        view.delegate = self
        return view
    }()
    
    lazy var searchView: BaseView = {
        let view = BaseView(frame: .zero)
        return view
    }()
    
    lazy var searchTextfield: UITextField = {
        let textfield = UITextField(frame: .zero)
        textfield.layer.cornerRadius = 5.0
        textfield.layer.borderColor = UIColor.light_grey.cgColor
        textfield.layer.borderWidth = 1.0
        textfield.font = .fromType(.primary(.italic, .h4))
        textfield.placeholder = "Search name, ranking".localized()
        textfield.textAlignment = .center
        return textfield
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(InteractiveUserListCell.self, forCellWithReuseIdentifier: InteractiveUserListCell.cellIdentifier())
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        return collectionView
    }()

    let viewModel = NotificationListViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = TextManager.listText.localized().uppercased()
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "icon-sort-list-index")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(sortButton_didPressed))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        
        setupStackView()
        setupPageMenu()
        setupSearchView()
        setupSearchTextfield()
        setupCollectionView()
    }
    
    private func setupStackView() {
        self.view.addSubview(self.topStackView)
        self.topStackView.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8)
            }
            maker.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupPageMenu() {
        self.topStackView.addArrangedSubview(self.pageMenuView)
        self.pageMenuView.snp.makeConstraints { (maker) in
//            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(40)
        }
    }
    
    private func setupSearchView() {
        self.topStackView.addArrangedSubview(self.searchView)
        self.searchView.snp.makeConstraints { (maker) in
            maker.height.equalTo(50)
        }
    }
    
    private func setupSearchTextfield() {
        self.searchView.addSubview(self.searchTextfield)
        self.searchTextfield.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin_10)
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin_10)
        }
    }
    
    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.topStackView.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: self.view.width, height: 65)
        }
    }
    
    @objc func sortButton_didPressed() {
        
    }
}

extension InteractiveUserListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InteractiveUserListCell.cellIdentifier(), for: indexPath) as? InteractiveUserListCell
        cell?.binding()
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let contestAlbum = ContestAlbumRouter().navigate(from: self.navigationController, transitionType: .push, animated: true) as? ContestAlbumViewController
//        contestAlbum?.viewModel.contest = self.viewModel.contest
    }
}

extension InteractiveUserListViewController: InteractivePageMenuDelegate {
    func pageMenu_didSelected(at index: Int) {
        
    }
}
