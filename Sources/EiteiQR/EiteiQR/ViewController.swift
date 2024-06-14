import UIKit

public class ViewController: UIViewController, QRScannerCodeDelegate ,CreatorViewControllerDelegate {
    
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
    var createIcon : UIImageView!
    // 聲明CreatorViewController的實例
    private var creatorViewController: CreatorViewController!
    
    // 掃碼数据集
    var scanData: [(String, String, String)] = []
    
    // 生成二維碼数据集
    var createData: [(String, String, String)] = []
    
    // 當前Table的數據源
    var currentData: [(String, String, String)] = []
    
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // 提前創建CreatorViewController實例
        creatorViewController = CreatorViewController()
        creatorViewController.modalPresentationStyle = .formSheet
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
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.leading.equalTo(self.view).offset(10)
            make.trailing.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.view).offset(-100)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "CustomCell")
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
        
        // History 標籤按鈕
        let historyTabButton = UIButton()
        historyTabButton.setTitle("History", for: .normal)
        historyTabButton.setTitleColor(UIColor.white, for: .normal)
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
        
        createTabButton.setTitle("Create", for: .normal)
        createTabButton.setTitleColor(UIColor.white, for: .normal)
        createTabButton.addTarget(self, action: #selector(createIconTapped), for: .touchUpInside)
        
        bottomBarView.addSubview(createTabButton)
        
        // 初始化createIcon
        createIcon = UIImageView(image: UIImage(named: "icon_create"))
        bottomBarView.addSubview(createIcon)
        
        createIcon.snp.makeConstraints { make in
            make.centerX.equalTo(createTabButton.snp.centerX)
            make.bottom.equalTo(createTabButton.snp.top).offset(-5)
            make.width.height.equalTo(30)
        }
        
        
        // 添加createIcon的點擊事件
        let createIconTapGesture = UITapGestureRecognizer(target: self, action: #selector(createIconTapped))
        createIcon.isUserInteractionEnabled = true
        createIcon.addGestureRecognizer(createIconTapGesture)
        
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
    
    private func addScanResultToData(result: String) {
        // 获取当前日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        
        // 根据当前 Segment 设置描述信息
        var description = segmentedControl.selectedIndex == 0 ? "掃碼時間：" : "添加時間："
        description = description + TimeUtil.getCurrentTimeString();
        
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
    
    // 點擊生成圖標的時候
    @objc private func createIconTapped() {
        // 先使用 animateButtonTap 開始動畫效果
        animateButtonTap(sender: createTabButton) { [weak self] in
            // 當動畫結束後，開始進一步動畫效果和展示 CreatorViewController
            UIView.animate(withDuration: 0.3, animations: {
                self?.createIcon.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self?.createIcon.alpha = 0.5
            }) { [self] _ in
                // 展示 CreatorViewController
                self?.present(self!.creatorViewController, animated: true, completion: {
                    
                    // 作為代理
                    self!.creatorViewController.delegate = self
                    
                    // 隱藏 QRCode View
                    self!.creatorViewController.qrCodeView.isHidden = true
                    self!.creatorViewController.dashedBorderLayer.isHidden = false
                    
                    // 清除 URL 文本框內容
                    self!.creatorViewController.urlTextField.text = ""
                    
                    // 重置顏色控件
                    self!.creatorViewController.checkmarkControl.selectedIndex = 2
                    // 恢復動畫效果
                    UIView.animate(withDuration: 0.3) {
                        self?.createIcon.transform = CGAffineTransform.identity
                        self?.createIcon.alpha = 1.0
                    }
                })
            }
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
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 返回當前數據集的行數
        return currentData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! HistoryCell
        // 配置表格單元格
        let data = currentData[indexPath.row]
        
        
        cell.configure(with: data.0, subtitle: data.1, date: data.2)
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
        return 10
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 設置選擇樣式
        cell.selectionStyle = .none
    }
    
    func didSaveQRCode(url: String, color: String, date: String) {
        let newEntry = (url, color, date)
        createData.append(newEntry)
        
        // 存儲到本地
        saveDataToUserDefaults()
        
        // 把數據更新進表格的數據源
        currentData.append(newEntry)
        // 更新UI或進行其他操作
        tableView.reloadData()
        
    }
}

// 定義一個代理協議，這個協議包含Creator創建二維碼之後，將數據回傳的方法
protocol CreatorViewControllerDelegate: AnyObject {
    
    func didSaveQRCode(url: String, color: String, date: String)
}
