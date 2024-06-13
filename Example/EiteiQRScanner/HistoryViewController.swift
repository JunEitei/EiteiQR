//
//  HistoryViewController.swift
//  EiteiQR
//
//  Created by damao on 2024/6/13.
//

import UIKit
import EiteiQR

class HistoryViewController: UIViewController, QRScannerCodeDelegate {
    
    // MARK: - QRScannerCodeDelegate Methods
    
    func qrScanner(_ controller: UIViewController, didScanQRCodeWithResult result: String) {
        print("掃描結果：\(result)")
        controller.dismiss(animated: true, completion: nil)
    }
    
    func qrScanner(_ controller: UIViewController, didFailWithError error: EiteiQR.QRCodeError) {
        print("掃描錯誤：\(error.localizedDescription)")
        controller.dismiss(animated: true, completion: nil)
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("QR 掃描器已取消")
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Properties
    
    let tableView = UITableView()
    let segmentedControl = EiteiSegmentedControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSegmentedControl()
        setupTableView()
        setupBottomBarView()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
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
    }
    
    private func setupSegmentedControl() {
        // 配置 SegmentedControl
        segmentedControl.items = ["Scan", "Create"]
        segmentedControl.textDefaultColor = UIColor(hex: "#feb600")
        segmentedControl.textSelectedColor = UIColor(hex: "#feb600")
        segmentedControl.underlineColor = UIColor(hex: "#feb600")
        segmentedControl.backgroundColor = UIColor.clear
        self.view.addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(70)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(40)
        }
    }
    
    private func setupTableView() {
        // 設置表格視圖
        tableView.backgroundColor = UIColor(hex: "#303030")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.leading.equalTo(self.view).offset(10)
            make.trailing.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.view).offset(-100)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "CustomCell")
        
        // 設置選中回調
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    private func setupBottomBarView() {
        // 設置底部欄視圖
        let bottomBarView = UIView()
        bottomBarView.backgroundColor = UIColor(hex: "#333333")
        bottomBarView.layer.shadowColor = UIColor.black.cgColor
        bottomBarView.layer.shadowOpacity = 0.5
        bottomBarView.layer.shadowOffset = CGSize(width: 0, height: -5)
        bottomBarView.layer.shadowRadius = 10
        self.view.addSubview(bottomBarView)
        
        bottomBarView.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.leading.trailing.bottom.equalTo(self.view)
        }
        
        // 添加凹進去的半圓形曲線
        let curveLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        // 左曲線
        path.move(to: CGPoint(x: 0, y: 0))
        path.addQuadCurve(to: CGPoint(x: self.view.frame.width / 2, y: 90), controlPoint: CGPoint(x: self.view.frame.width / 2, y: -90))
        
        // 右曲線
        path.addQuadCurve(to: CGPoint(x: self.view.frame.width / 2, y: 100), controlPoint: CGPoint(x: self.view.frame.width / 2, y: 150))
        path.addQuadCurve(to: CGPoint(x: self.view.frame.width, y: 0), controlPoint: CGPoint(x: self.view.frame.width / 2, y: -90))
        
        path.close()
        
        curveLayer.path = path.cgPath
        curveLayer.fillColor = UIColor(hex: "#333333").cgColor
        bottomBarView.layer.addSublayer(curveLayer)
        
        // 确保曲线位于底部视图的最底层
        bottomBarView.layer.insertSublayer(curveLayer, at: 0)
        
        // History 標籤按鈕
        let historyTabButton = UIButton()
        historyTabButton.setTitle("History", for: .normal)
        historyTabButton.setTitleColor(UIColor(hex: "#ffffff"), for: .normal)
        bottomBarView.addSubview(historyTabButton)
        
        let historyIcon = UIImageView(image: UIImage(named: "icon_history"))
        bottomBarView.addSubview(historyIcon)
        
        historyIcon.snp.makeConstraints { make in
            make.centerX.equalTo(historyTabButton.snp.centerX)
            make.bottom.equalTo(historyTabButton.snp.top).offset(-5)
            make.width.height.equalTo(30)
        }
        
        historyTabButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBarView)
            make.leading.equalTo(bottomBarView).offset(50)
        }
        
        historyTabButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        let createTabButton = UIButton()
        createTabButton.setTitle("Create", for: .normal)
        createTabButton.setTitleColor(UIColor(hex: "#ffffff"), for: .normal)
        bottomBarView.addSubview(createTabButton)
        
        let createIcon = UIImageView(image: UIImage(named: "icon_create"))
        bottomBarView.addSubview(createIcon)
        
        createIcon.snp.makeConstraints { make in
            make.centerX.equalTo(createTabButton.snp.centerX)
            make.bottom.equalTo(createTabButton.snp.top).offset(-5)
            make.width.height.equalTo(30)
        }
        
        createTabButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBarView)
            make.trailing.equalTo(bottomBarView).offset(-50)
        }
        
        createTabButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        
        // 中間的大按鈕
        let scanButton = EiteiScanButton()
        scanButton.onScanButtonTapped = { [weak self] in
            self?.presentQRCodeScanner()
        }
        bottomBarView.addSubview(scanButton)
        
        // 設置按鈕的約束
        scanButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.width.height.equalTo(90)
        }
        
        
    }
    
    @objc private func segmentedControlValueChanged() {
        // 根據選中的選項進行相應處理
        let selectedIndex = segmentedControl.selectedIndex
        print("選擇了 \(segmentedControl.items[selectedIndex])")
        // 可在此處實現對應的邏輯
    }
    
    private func presentQRCodeScanner() {
        
        // 設置 QR 碼掃描器的配置對象
        var configuration = QRScannerConfiguration()
        
        // 設置相機按鈕的圖示
        configuration.cameraImage = UIImage(named: "camera")
        
        // 設置閃光燈開啟按鈕的圖示
        configuration.flashOnImage = UIImage(named: "flash-on")
        
        // 設置相冊按鈕的圖示
        configuration.galleryImage = UIImage(named: "photos")
        
        // 設置掃描界面的標題
        configuration.title = "掃描二維碼"
        
        // 設置掃描提示文字
        configuration.hint = "請對準二維碼，進行掃描"
        
        // 設置從相冊選取二維碼的按鈕標題
        configuration.uploadFromPhotosTitle = "從相簿選取"
        
        // 設置無效二維碼的提示框標題
        configuration.invalidQRCodeAlertTitle = "無效的二維碼"
        
        // 設置無效二維碼提示框的確定按鈕標題
        configuration.invalidQRCodeAlertActionTitle = "確定"
        
        // 設置取消按鈕標題
        configuration.cancelButtonTitle = "取消"
        
        let scanner = QRCodeScannerController(qrScannerConfiguration: configuration) // 創建掃描器視圖控制器
        scanner.delegate = self // 設置委託對象，實現掃描結果的回調
        self.present(scanner, animated: true, completion: nil) // 顯示掃描器視圖控制器
        
        
    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 返回數據行數
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! HistoryCell
        // 配置表格單元格
        cell.configure(with: "https://www.google.com.tw", subtitle: "Foraging for wild food", date: "2023-09-10")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 設置單元格高度
        return 85
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // 設置表頭高度
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 設置選擇樣式
        cell.selectionStyle = .none
    }
}
