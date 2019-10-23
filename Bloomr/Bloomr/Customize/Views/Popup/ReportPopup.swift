//
//  ReportPopup.swift
//  Bloomr
//
//  Created by Tan Tan on 8/27/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class ReportPopup: BaseView {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(ReportTableViewCell.self, forCellReuseIdentifier: ReportTableViewCell.cellIdentifier())
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    let dataSource = ["Chọn lý do Báo Cáo", "Nội dung gây thù ghét", "Vi phạm quyền sở hữu", "Nội dung thô tục", "Cảm ơn đã cho chúng tôi biết thông tin."]
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        
        setupTableView()
    }
    
    private func setupTableView() {
        self.addSubview(tableView)
        self.bringSubviewToFront(tableView)
        self.tableView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.buttonHeight_40)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.buttonHeight_40)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(self.tableView.snp.width)
        }
    }
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
}

extension ReportPopup: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.height / CGFloat(dataSource.count)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.cellIdentifier(), for: indexPath) as? ReportTableViewCell
        let text = dataSource[indexPath.row]
        switch indexPath.row {
        case 0:
            cell?.setTitle(text, type: .title)
        case dataSource.count - 1:
            cell?.setTitle(text, type: .end)
        default:
            cell?.setTitle(text, type: .content)
        }
        
        if indexPath.row == dataSource.count - 2 {
            cell?.bottomLine.isHidden = true
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == dataSource.count - 1 { return }
        self.dismiss()
    }
}
