//
//  ViewController.swift
//  EiteiQR
//
//  Created by damao on 2024/6/13.
//

import UIKit
#if canImport(QRCode)
import QRCode
#endif


class QRHistoryViewController: UIViewController, QRScannerCodeDelegate ,CreatorViewControllerDelegate,UIViewControllerTransitioningDelegate {
    
    // MARK: - QRScannerCodeDelegate Methods
    
    public func qrScanner(_ controller: UIViewController, didScanQRCodeWithResult result: String) {
        print("掃描結果：\(result)")
        addScanResultToData(result: result)
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func qrScanner(_ controller: UIViewController, didFailWithError error: EiteiQR.QRCodeError) {
        print("掃描錯誤：\(error.localizedDescription)")
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func qrScannerDidCancel(_ controller: UIViewController) {
        print("掃描器已取消")
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Properties
    
    // 提前聲明一些變量
    let tableView = UITableView()
    let segmentedControl = EiteiSegmentedControl()
    let createTabButton = UIButton()
    var createIcon = UIImageView()

    // 掃碼数据集
    var scanData: [(String, String, String)] = []
    
    // 生成二維碼数据集
    var createData: [(String, String, String)] = []
    
    // 當前Table的數據源
    var currentData: [(String, String, String)] = []
    
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFromUserDefaults() // 從本地加载数据
        currentData = scanData // 初始化数据为 scanData
        
        setupView()
        setupSegmentedControl()
        setupTableView()
        setupBottomBarView()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        // 設置背景顏色
        self.view.backgroundColor = .eiteiGray
        
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
        segmentedControl.textDefaultColor = .eiteiOrange
        segmentedControl.textSelectedColor = .eiteiOrange
        segmentedControl.underlineColor = .eiteiOrange
        segmentedControl.backgroundColor = UIColor.clear
        self.view.addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(70)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(40)
        }
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    private func setupTableView() {
        // 設置表格視圖
        tableView.backgroundColor = .eiteiGray
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.view.addSubview(tableView)
        
        // 表格約束設置，保證表格剛好被遮擋一點點
        tableView.snp.makeConstraints { make in
            
            // 設置間距，防止Table遮擋Segment
            make.top.equalTo(segmentedControl.snp.bottom).offset(5)
            make.leading.equalTo(self.view).offset(11)
            // 表格右邊距離
            make.trailing.equalTo(self.view).offset(-5)
            // 表格底部距離，關乎被遮擋多少（重要）
            make.bottom.equalTo(self.view).offset(-130)
        }
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "CustomCell")
        
        
    }
    
    private func updateTableViewHeight() {
        let maxVisibleRows = 5
        let rowHeight: CGFloat = 85 // 单元格高度
        
        // 计算表格视图的总高度
        let tableHeight = CGFloat(min(currentData.count, maxVisibleRows)) * rowHeight - 100
        
        tableView.snp.updateConstraints { make in
            make.height.equalTo(tableHeight)
        }
        tableView.layoutIfNeeded() // 更新布局
    }
    
    private func setupBottomBarView() {
        // 設置底部欄視圖
        let bottomBarView = UIView()
        bottomBarView.backgroundColor = .eiteiBackground
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
        curveLayer.fillColor = UIColor.eiteiGray.cgColor
        bottomBarView.layer.addSublayer(curveLayer)
        
        // 确保曲线位于底部视图的最底层
        bottomBarView.layer.insertSublayer(curveLayer, at: 0)
        // 设置 zPosition 防止遮擋掃碼按鈕
        curveLayer.zPosition = -1
        
        
        
        // 中間的大按鈕
        let scanButton = EiteiScanButton()
        scanButton.onScanButtonTapped = { [weak self] in
            // 動畫效果
            self?.animateScanButtonTap(scanButton: scanButton) {
                // 彈出掃碼界面
                self?.presentQRCodeScanner()
            }        }
        
        // 添加掃碼按鈕
        bottomBarView.addSubview(scanButton)
        
        // 剪裁成正圓
        scanButton.clipsToBounds = true
        
        // 設置按鈕的約束
        scanButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.width.height.equalTo(110)
        }
        
        // 把三個按钮放到最上层
        bottomBarView.bringSubviewToFront(scanButton)
        
    }
    
    @objc private func segmentedControlValueChanged() {
        // 根據選中的選項進行相應處理
        let selectedIndex = segmentedControl.selectedIndex
        if selectedIndex == 0 {
            currentData = scanData
        } else {
            currentData = createData
        }
        tableView.reloadData() // 刷新表格视图
    }
    
    private func presentQRCodeScanner() {
        // 設置 QR 碼掃描器的配置對象
        var configuration = QRScannerConfiguration()
        
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
    
    private func addScanResultToData(result: String) {
        // 获取当前日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        
        // 设置描述信息：時間
        let description = "掃碼時間：" + TimeUtil.getCurrentTimeString()
        
        // 添加数据到当前数据集合
        let newEntry = (result, description, currentDate)
        
        // 那麼就把數據添加到掃碼的數組裡
        scanData.append(newEntry)
        
        // 再添加到表格數據中
        currentData.append(newEntry)
        
        // 更新表格
        tableView.reloadData()
    }
    
    // 把數據存放到本地
    private func saveDataToUserDefaults() {
        let defaults = UserDefaults.standard
        
        // 映射出來
        let scanDataArray = scanData.map { [$0.0, $0.1, $0.2] }
        let createDataArray = createData.map { [$0.0, $0.1, $0.2] }
        
        // 如果是掃碼的數據，放到這裡
        defaults.set(scanDataArray, forKey: "scanData")
        
        // 如果是生成二維碼的數據，放到這裡
        defaults.set(createDataArray, forKey: "createData")
    }
    
    // 從本地讀取歷史數據
    private func loadDataFromUserDefaults() {
        let defaults = UserDefaults.standard
        
        if let scanDataArray = defaults.array(forKey: "scanData") as? [[String]] {
            scanData = scanDataArray.map { ($0[0], $0[1], $0[2]) }
        }
        
        if let createDataArray = defaults.array(forKey: "createData") as? [[String]] {
            createData = createDataArray.map { ($0[0], $0[1], $0[2]) }
        }
    }
    
    
    // 展示生成器之前的動畫
    private func animateButtonTap(sender: UIButton, completion: @escaping () -> Void) {
        let originalScale = sender.transform
        
        UIView.animate(withDuration: 0.2, animations: {
            sender.transform = originalScale.scaledBy(x: 0.7, y: 0.7)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                sender.transform = originalScale
            }
            completion()
        }
    }
    
    // Scan按鈕押しで效果
    private func animateScanButtonTap(scanButton: UIButton, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.071, animations: {
            
            // 採用黃金分割比例
            scanButton.transform = CGAffineTransform(scaleX: 0.68, y: 0.68)
        }) { _ in
            UIView.animate(withDuration: 0.071, animations: {
                
                // 押しで
                scanButton.transform = CGAffineTransform.identity
            }) { _ in
                
                
                completion()
            }
        }
    }
    
    // Scan按鈕正弦波發光效果
    private func addGlowEffect(to button: UIButton) {
        // 設置陰影顏色和偏移量
        button.layer.shadowColor = UIColor.eiteiOrange.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowOpacity = 0.9
        button.layer.shadowRadius = 20
        
        // 創建動畫，使陰影半徑隨時間變化
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 0
        glowAnimation.toValue = 30
        glowAnimation.duration = 0.5
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = .infinity
        
        // 創建動畫，使透明度隨時間變化
        let opacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        opacityAnimation.fromValue = 0.5
        opacityAnimation.toValue = 1.0
        opacityAnimation.duration = 0.5
        opacityAnimation.autoreverses = true
        opacityAnimation.repeatCount = .infinity
        
        // 組合動畫
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.5
        animationGroup.repeatCount = .infinity
        animationGroup.autoreverses = true
        animationGroup.animations = [glowAnimation, opacityAnimation]
        
        // 添加動畫到按鈕層
        button.layer.add(animationGroup, forKey: "glowEffect")
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    
    func presentImageViewController(with image: UIImage) {
        let imageVC = EiteiImageViewController()
        imageVC.image = image
        imageVC.modalPresentationStyle = .custom
        imageVC.transitioningDelegate = self
        present(imageVC, animated: true, completion: nil)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return EiteiPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension QRHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 返回當前數據集的行數
        return currentData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! HistoryCell
        // 配置表格單元格
        let data = currentData[indexPath.row]
        
        // 先利用Cell自身內部方法來配置
        cell.configure(with: data.0, subtitle: data.1, date: data.2)
        
        // 如果是來自生成的話，那麼展示出彩色
        if segmentedControl.selectedIndex == 1 {
            
            cell.iconImageView.backgroundColor = UIColor.init(hexString: cell.descriptionLabel.text!)
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            // 將字符串重新解析為 Date 對象
            guard let date = dateFormatter.date(from: data.2) else {
                print("無法解析日期時間字符串")
                return cell
            }
            
            // 利用格式化函數來分離
            let dateOnlyFormatter = DateFormatter()
            dateOnlyFormatter.dateFormat = "yyyy-MM-dd"
            let timeOnlyFormatter = DateFormatter()
            timeOnlyFormatter.dateFormat = "HH:mm:ss"
            
            // 把date中日期截取出來並且展示
            cell.dateLabel.text = dateOnlyFormatter.string(from: date)
            // 同時把date中時間截取出來並且展示
            cell.descriptionLabel.text = "生成時間：" + timeOnlyFormatter.string(from: date)
            
            // 按鈕圖標取決於二維碼內容是否為URL
            cell.iconImageView.image = Eitei.shared.loadImage(named:  isValidURL(data.0) ? "icon_website" : "icon_text")
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 設置單元格高度
        return 85
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // 設置表頭高度
        return 0
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 設置選擇樣式
        cell.selectionStyle = .none
    }
    
    // Cell點擊事件
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // 獲取到Cell
        let cell = tableView.cellForRow(at: indexPath) as! HistoryCell
        
        // 獲取到二維碼的內容
        let qrCodeContent = cell.urlLabel.text!
        
        // 生成二維碼並展示
        generateQRCode(from: qrCodeContent)
        
    }
    
    // MARK: - QR Code Generator
    private func generateQRCode(from text: String) {
        do {
            let imagedata = try QRCode.build
                .text(text)
                .quietZonePixelCount(3)
                .foregroundColor(UIColor.eiteiSuperOrange.cgColor)
                .backgroundColor(UIColor.eiteiGray.cgColor)
                .background.cornerRadius(3)
                .onPixels.shape(QRCode.PixelShape.CurvePixel())
                .eye.shape(QRCode.EyeShape.Teardrop())
                .generate.image(dimension: 600, representation: .png())
            
            // 展示生成的圖片
            presentImageViewController(with: UIImage(data: imagedata)!)
            
        } catch {
            print("生成 QR Code 時發生錯誤：\(error.localizedDescription)")
        }
    }
    
    // 保存圖片回調
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        if let error = error {
            alert.title = "Save error"
            alert.message = error.localizedDescription
        } else {
            alert.title = "Saved!"
            alert.message = "Your QR Code image has been saved to your photos."
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { [weak self] (action, view, completionHandler) in
            self?.deleteData(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    private func deleteData(at indexPath: IndexPath) {
        // 从当前数据中删除
        let itemToDelete = currentData[indexPath.row]
        
        if segmentedControl.selectedIndex == 0 {
            scanData.removeAll { $0 == itemToDelete }
            currentData = scanData
        } else {
            createData.removeAll { $0 == itemToDelete }
            currentData = createData
        }
        
        // 更新数据源并保存到 UserDefaults
        saveDataToUserDefaults()
        
        // 刷新表格视图
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    // 通過正則判斷是否是URL
    func isValidURL(_ urlString: String) -> Bool {
        let urlPattern = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
        let urlPredicate = NSPredicate(format: "SELF MATCHES %@", urlPattern)
        return urlPredicate.evaluate(with: urlString)
    }
    
    // 成功保存二維碼之後
    func didSaveQRCode(url: String, color: String, date: String) {
        
        // 手動切換選項卡
        segmentedControl.manualSelectSegment(at: 1)
        
        
        // 把數據更新進Create對應的數據源
        let newEntry = (url, color, date)
        createData.append(newEntry)
        
        // 存儲到本地
        saveDataToUserDefaults()
        
        // 把數據更新進表格的數據源
        currentData.append(newEntry)
        
        
        // 刷新表格
        tableView.reloadData()
        
    }
}
