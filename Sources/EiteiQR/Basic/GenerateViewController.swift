//
//  GenerateViewController.swift
//  EiteiQRScanner
//
//  Created by damao on 2024/6/6.
//

#if canImport(UIKit)
import UIKit

class GenerateViewController: UIViewController, UITextFieldDelegate {
    
    
    // 二維碼視圖，用於顯示生成的二維碼
    var qrCodeView: QRCodeView!
    
    // 容器視圖，包含所有子視圖
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    // 文本輸入框，允許用戶輸入文本生成二維碼
    public let inputTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "輸入文本生成二維碼"
        textField.returnKeyType = .done // 設置返回鍵為完成
        return textField
    }()
    
    
    // 提示文本，告訴用戶長按保存到相冊
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "長按以保存到相冊"
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    // 歷史紀錄數組
    var historyRecords: [String] = []
    
    // 表格視圖
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設置界面
        setupViews()
        
        // 設置二維碼的默認設計
        setupDefaultQRCodeDesign()
        
        // 添加長按手勢識別器
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.qrCodeView.addGestureRecognizer(longPressGesture)
        
        // 隱藏鍵盤的識別器
        setupTapGesture()
        
        // 設置文本框代理
        inputTextField.delegate = self
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        
        
        
        // 添加容器視圖到主視圖
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
        
        // 添加文本輸入框到容器視圖，設置為和屏幕等寬
        containerView.addSubview(inputTextField)
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(10)
            make.left.equalTo(containerView).offset(10)
            make.right.equalTo(containerView).offset(-10)
            make.height.equalTo(40)
        }
        

        // 添加二維碼視圖到容器視圖
        qrCodeView = QRCodeView()

        containerView.addSubview(qrCodeView)
        qrCodeView.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(60)  // 增加距離
            make.centerX.equalTo(containerView)
            make.width.height.equalTo(200)
        }
        
        // 添加提示文本到容器視圖
        containerView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.top.equalTo(qrCodeView.snp.bottom).offset(60)  // 增加距離
            make.centerX.equalTo(containerView)
            make.bottom.equalTo(containerView).offset(-20) // 保持容器視圖的底部邊界，並微調底部邊距
        }
        
        // 設置表格視圖
        setupTableView()
        

    }
    
    // 設置表格視圖
    private func setupTableView() {
        // 表格背景色
        tableView.backgroundColor = .black

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell") // 註冊表格單元格
        tableView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(10) // 設置表格視圖距離容器視圖的距離
            make.left.right.equalTo(view).inset(20) // 設置表格視圖的左右邊距
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20) // 設置表格視圖距離底部的距離
        }
        
        // 設置表格視圖的標題
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40)) // 創建表格標題視圖
        headerView.backgroundColor = .black // 設置表頭視圖的背景顏色為白色
        
        let headerLabel = UILabel(frame: headerView.bounds) // 創建標題標籤
        headerLabel.text = "歷史紀錄" // 設置標題文本
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16) // 設置標題文字的字體樣式
        headerLabel.textAlignment = .center // 設置標題文字的對齊方式為居中
        headerLabel.textColor = .black // 設置標題文字顏色為黑色
        headerView.addSubview(headerLabel) // 將標題標籤添加到表頭視圖中
        tableView.tableHeaderView = headerView // 設置表格視圖的標題為我們剛剛創建的表頭視圖
        
        
    }
    
    
    private func setupDefaultQRCodeDesign() {
        // 設置二維碼的眼形狀為 UFO 形狀
        self.qrCodeView.design.shape.eye = QRCode.EyeShape.UFO()
        
        // 設置二維碼背景顏色為黑色
        self.qrCodeView.design.backgroundColor(CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1))
        
        // 設置二維碼的像素形狀為方形，內縮比例為 0.7
        self.qrCodeView.design.shape.onPixels = QRCode.PixelShape.Square(insetFraction: 0.7)
        
        // 設置二維碼像素的前景顏色為白色
        self.qrCodeView.design.style.onPixels = QRCode.FillStyle.Solid(gray: 1)
        
        // 設置二維碼像素的背景顏色，透明度為 0.2
        self.qrCodeView.design.style.onPixelsBackground = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 0.2)
        
        // 設置二維碼的非像素區域形狀為方形，內縮比例為 0.7
        self.qrCodeView.design.shape.offPixels = QRCode.PixelShape.Square(insetFraction: 0.7)
        
        // 設置二維碼非像素區域的顏色為黑色
        self.qrCodeView.design.style.offPixels = QRCode.FillStyle.Solid(gray: 0)
        
        // 設置二維碼非像素區域的背景顏色，透明度為 0.2
        self.qrCodeView.design.style.offPixelsBackground = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.2)
        
        // 設置二維碼視圖的背景顏色為透明
        self.qrCodeView.backgroundColor = .clear
    }
    
    // MARK: - Actions
    
    @objc private func generateQRCodeButtonPressed() {
        
        
        // 檢查輸入框是否有文本
        guard let text = inputTextField.text, !text.isEmpty else {
            let alert = UIAlertController(title: "錯誤", message: "請輸入文本以生成二維碼", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        // 生成二維碼
        generateQRCode(withText: text)
    }
    
    // 點擊背景的事件
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // 隱藏鍵盤的時候
    @objc func dismissKeyboard() {
        
        // 隱藏鍵盤
        view.endEditing(true)
        
        // 順便重新生成
        generateQRCode(withText: inputTextField.text ?? "");
    }
    
    
    
    public func generateQRCode(withText text: String) {
        // 創建 QRCode.Document 對象，指定文本內容和錯誤糾正等級
        let doc = QRCode.Document(
            utf8String: text,            // 設置要編碼的文本
            errorCorrection: .high       // 設置錯誤糾正等級為高
        )
        
        
        // 更新二維碼視圖的文檔數據，並重新構建二維碼
        qrCodeView.document = doc
        
        // 重新設置二維碼的默認設計
        setupDefaultQRCodeDesign()
        
        // 根據內容重新生成二維碼
        qrCodeView.rebuildQRCode()
        
        // 將結果添加到歷史紀錄中
        addToHistory(result: text)
    }
    
    
    // 將結果添加到歷史紀錄中
    private func addToHistory(result: String) {
        historyRecords.append(result)
        tableView.reloadData()  // 刷新表格視圖
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // 獲取 qrCodeView 上的二維碼圖片
            guard let qrImage = self.qrCodeView.asImage() else { return }
            
            // 保存圖片到相冊
            UIImageWriteToSavedPhotosAlbum(qrImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // 保存失敗，顯示錯誤提示
            let alert = UIAlertController(title: "錯誤", message: "保存圖片時出現錯誤：\(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            // 保存成功，顯示成功提示
            let alert = UIAlertController(title: "成功", message: "圖片已保存到相冊。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 當用戶點擊鍵盤上的“完成”按鈕時，生成二維碼
        guard let text = textField.text, !text.isEmpty else {
            let alert = UIAlertController(title: "錯誤", message: "請輸入文本以生成二維碼", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        generateQRCode(withText: text)
        textField.resignFirstResponder() // 隱藏鍵盤
        return true
    }
}

// MARK: - Extension

extension UIView {
    // 截圖 UIView 的內容為 UIImage
    func asImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


extension GenerateViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = historyRecords[indexPath.row]
        return cell
    }
}

#endif
