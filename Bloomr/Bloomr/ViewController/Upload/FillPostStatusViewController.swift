//
//  FillPostStatusViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/28/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class FillPostStatusViewController: BaseViewController {
    
    let updateStatusView: UpdatePostStatusView = {
        let view = UpdatePostStatusView(frame: .zero)
        return view
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
//        self.navigationController?.view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
//        setupUpdateStatusView()
    }
    
    private func setupUpdateStatusView() {
        self.view.addSubview(self.updateStatusView)
        self.updateStatusView.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8)
            }
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(200)
        }
    }
}
