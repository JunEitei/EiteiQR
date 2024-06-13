//
//  HistoryViewController.swift
//  EiteiQRScanner
//
//  Created by damao on 2024/6/13.
//

import UIKit

class HistoryViewController: UIViewController {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設置背景顏色
        self.view.backgroundColor = UIColor(hex: "#303030")
        
        // 自定義頂部標題視圖
        let customTitleView = UIView()
        customTitleView.backgroundColor = UIColor.clear
        self.view.addSubview(customTitleView)
        
        customTitleView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(60)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "History"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .center
        customTitleView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(customTitleView)
        }
        
        // 設置表格視圖
        tableView.backgroundColor = UIColor(hex: "#303030")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false // 隱藏垂直滾動條
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0) // 上部填充
        self.view.addSubview(tableView)
        
        // 使用 SnapKit 設置表格視圖的佈局
        tableView.snp.makeConstraints { make in
            make.top.equalTo(customTitleView.snp.bottom).offset(10)
            make.leading.equalTo(self.view).offset(10) // 左邊距設置為10
            make.trailing.equalTo(self.view).offset(-10) // 右邊距設置為10
            make.bottom.equalTo(self.view).offset(-100)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "CustomCell")
        
        // 設置底部欄視圖
        let bottomBarView = UIView()
        bottomBarView.backgroundColor = UIColor(hex: "#333333")
        bottomBarView.layer.shadowColor = UIColor.black.cgColor
        bottomBarView.layer.shadowOpacity = 0.5
        bottomBarView.layer.shadowOffset = CGSize(width: 0, height: -5)
        bottomBarView.layer.shadowRadius = 10
        self.view.addSubview(bottomBarView)
        
        // 使用 SnapKit 設置底部欄視圖的佈局
        bottomBarView.snp.makeConstraints { make in
            make.height.equalTo(120) // 增加高度
            make.leading.trailing.bottom.equalTo(self.view)
        }
        
        // History 標籤按鈕
        let historyTabButton = UIButton()
        historyTabButton.setTitle("History", for: .normal)
        historyTabButton.setTitleColor(UIColor(hex: "#ffffff"), for: .normal)
        bottomBarView.addSubview(historyTabButton)
        
        // 添加 History 圖標
        let historyIcon = UIImageView(image: UIImage(named: "icon_history"))
        bottomBarView.addSubview(historyIcon)
        
        // 使用 SnapKit 設置 History 圖標和按鈕的佈局
        historyIcon.snp.makeConstraints { make in
            make.centerX.equalTo(historyTabButton.snp.centerX)
            make.bottom.equalTo(historyTabButton.snp.top).offset(-5)
            make.width.height.equalTo(30)
        }
        
        historyTabButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBarView)
            make.leading.equalTo(bottomBarView).offset(50)
        }
        
        historyTabButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        // 中間的大按鈕
        let scanTabButton = UIButton()
        scanTabButton.backgroundColor = UIColor(hex: "#feb600")
        scanTabButton.layer.cornerRadius = 30
        scanTabButton.layer.masksToBounds = true
        scanTabButton.layer.borderWidth = 4
        scanTabButton.layer.borderColor = UIColor(hex: "#feb600").cgColor
        bottomBarView.addSubview(scanTabButton)
        
        // 使用 SnapKit 設置中間的大按鈕的佈局
        scanTabButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBarView.snp.top).offset(60)
            make.centerX.equalTo(bottomBarView)
            make.width.height.equalTo(60)
        }
        
        // Create 標籤按鈕
        let createTabButton = UIButton()
        createTabButton.setTitle("Create", for: .normal)
        createTabButton.setTitleColor(UIColor(hex: "#ffffff"), for: .normal)
        bottomBarView.addSubview(createTabButton)
        
        // 添加 Create 圖標
        let createIcon = UIImageView(image: UIImage(named: "icon_create"))
        bottomBarView.addSubview(createIcon)
        
        // 使用 SnapKit 設置 Create 圖標和按鈕的佈局
        createIcon.snp.makeConstraints { make in
            make.centerX.equalTo(createTabButton.snp.centerX)
            make.bottom.equalTo(createTabButton.snp.top).offset(-5)
            make.width.height.equalTo(30)
        }
        
        createTabButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBarView)
            make.trailing.equalTo(bottomBarView).offset(-50)
        }
        
        createTabButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        // 更新表格視圖樣式
        tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 // 示例數據的數量
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! HistoryCell
        // 配置 cell 與示例數據
        cell.configure(with: "https://www.google.com.tw", subtitle: "Foraging for wild food", date: "2023-09-10")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85 // 增加 cell 高度以適應圓角和間距
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10 // 設置 Cell 之間的間距
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none // 關閉選中效果
    }
}

// UIColor 擴展，用於從十六進制代碼初始化
extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            self.init(white: 0.5, alpha: 1.0)
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

