//
//  AvailableContestsViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/9/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class AvailableContestsViewController: BaseViewController {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(AvailableContestCell.self, forCellWithReuseIdentifier: AvailableContestCell.cellIdentifier())
        collectionView.backgroundColor = .veryLightPinkTwo
        collectionView.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let viewModel = AvailableContestsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = TextManager.uploadText.localized().uppercased()
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupCollectionView()
        
        handleObservers()
    }
    
    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            let width = self.view.width
            layout.itemSize = CGSize(width: width, height: 60)
            layout.minimumLineSpacing = 1
        }
    }
    
    private func handleObservers() {
        self.viewModel.contests.subscribe(onNext: { (contests) in
            
        }).disposed(by: self.disposeBag)
    }
}

// MARK: - UICollectionViewDataSource
extension AvailableContestsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.contests.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvailableContestCell.cellIdentifier(), for: indexPath) as? AvailableContestCell else { return UICollectionViewCell() }
        cell.binding(self.viewModel.contests.value?[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = CompletionInfoContestRouter().navigate(from: self.navigationController, transitionType: .push, animated: true, completion: nil)
    }
}
