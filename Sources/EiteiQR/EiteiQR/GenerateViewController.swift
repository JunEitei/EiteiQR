//
//  GenerateViewController.swift
//  EiteiQRScanner
//
//  Created by damao on 2024/6/12.
//
#if canImport(UIKit)
import UIKit

class GenerateViewController: UIViewController, UITextFieldDelegate {
    
    // 宣告一個QRCodeView物件
    var qrCodeView: QRCodeView!
    
    // 設定容器視圖
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(
            white: 0.95,
            alpha: 1
        ) // 淺灰色背景
        view.layer.cornerRadius = 12 // 圓角
        view.layer.shadowColor = UIColor.gray.cgColor // 阴影顏色
        view.layer.shadowOpacity = 0.3 // 阴影透明度
        view.layer.shadowOffset = CGSize(
            width: 0,
            height: 2
        ) // 阴影偏移量
        view.layer.shadowRadius = 4 // 阴影半径
        return view
    }()
    
    // 設定輸入文字框
    public let inputTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "輸入文本生成二維碼" // 占位文字
        textField.returnKeyType = .done
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8 // 圓角
        textField.textColor = UIColor.darkGray
        textField.attributedPlaceholder = NSAttributedString(
            string: "輸入文本生成二維碼",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }()
    
    // 設定提示文字
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "長按以保存到相冊" // 提示信息
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(
            ofSize: 14
        )
        return label
    }()
    
    // 儲存歷史紀錄
    var historyRecords: [String] = []
    
    // 設定表格視圖
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(
            white: 0.95,
            alpha: 1
        ) // 與容器視圖相同的背景顏色
        tableView.separatorColor = UIColor.darkGray
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews() // 設定視圖
        setupDefaultQRCodeDesign() // 設定預設二維碼樣式
        
        // 設定長按手勢
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(
                handleLongPress
            )
        )
        self.qrCodeView.addGestureRecognizer(
            longPressGesture
        )
        
        setupTapGesture() // 設定點擊手勢
        inputTextField.delegate = self // 設定文字框代理
    }
    
    // 設定視圖方法
    private func setupViews() {
        self.view.backgroundColor = .white
        
        // 添加容器視圖
        self.view.addSubview(
            containerView
        )
        containerView.snp.makeConstraints { make in
            make.top.equalTo(
                view.safeAreaLayoutGuide
            ).offset(
                20
            )
            make.left.equalTo(
                view
            ).offset(
                20
            )
            make.right.equalTo(
                view
            ).offset(
                -20
            )
        }
        
        // 添加文字框
        containerView.addSubview(
            inputTextField
        )
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(
                containerView
            ).offset(
                20
            )
            make.left.equalTo(
                containerView
            ).offset(
                20
            )
            make.right.equalTo(
                containerView
            ).offset(
                -20
            )
            make.height.equalTo(
                40
            )
        }
        
        // 初始化QRCodeView並添加到容器視圖中
        qrCodeView = QRCodeView()
        containerView.addSubview(
            qrCodeView
        )
        qrCodeView.snp.makeConstraints { make in
            make.top.equalTo(
                inputTextField.snp.bottom
            ).offset(
                20
            )
            make.centerX.equalTo(
                containerView
            )
            make.width.height.equalTo(
                200
            )
        }
        
        // 添加提示文字
        containerView.addSubview(
            tipLabel
        )
        tipLabel.snp.makeConstraints { make in
            make.top.equalTo(
                qrCodeView.snp.bottom
            ).offset(
                20
            )
            make.centerX.equalTo(
                containerView
            )
            make.bottom.equalTo(
                containerView
            ).offset(
                -20
            )
        }
        
        setupTableView() // 設定表格視圖
    }
    
    // 設定表格視圖方法
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "Cell"
        )
        
        view.addSubview(
            tableView
        )
        tableView.snp.makeConstraints { make in
            make.top.equalTo(
                containerView.snp.bottom
            ).offset(
                20
            )
            make.left.right.equalTo(
                view
            ).inset(
                20
            )
            make.bottom.equalTo(
                view.safeAreaLayoutGuide
            ).offset(
                -20
            )
        }
        
        // 設定表格標題視圖
        let headerView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: tableView.frame.size.width,
                height: 40
            )
        )
        headerView.backgroundColor = UIColor(
            white: 0.95,
            alpha: 1
        )
        
        let headerLabel = UILabel(
            frame: headerView.bounds
        )
        headerLabel.text = "歷史紀錄" // 標題文字
        headerLabel.font = UIFont.boldSystemFont(
            ofSize: 16
        )
        headerLabel.textAlignment = .center
        headerLabel.textColor = .darkGray
        headerView.addSubview(
            headerLabel
        )
        tableView.tableHeaderView = headerView
    }
    
    // 設定預設二維碼樣式
    private func setupDefaultQRCodeDesign() {
        self.qrCodeView.design.shape.eye = QRCode.EyeShape.UFO()
        self.qrCodeView.design.backgroundColor(
            CGColor(
                srgbRed: 0.9,
                green: 0.9,
                blue: 0.9,
                alpha: 1
            )
        )
        self.qrCodeView.design.shape.onPixels = QRCode.PixelShape.Square(
            insetFraction: 0.7
        )
        self.qrCodeView.design.style.onPixels = QRCode.FillStyle.Solid(
            gray: 0
        )
        self.qrCodeView.design.style.onPixelsBackground = CGColor(
            srgbRed: 1,
            green: 1,
            blue: 1,
            alpha: 0.2
        )
        self.qrCodeView.design.shape.offPixels = QRCode.PixelShape.Square(
            insetFraction: 0.7
        )
        self.qrCodeView.design.style.offPixels = QRCode.FillStyle.Solid(
            gray: 0
        )
        self.qrCodeView.design.style.offPixelsBackground = CGColor(
            srgbRed: 0,
            green: 0,
            blue: 0,
            alpha: 0.2
        )
        self.qrCodeView.backgroundColor = .clear
    }
    
    // 生成二維碼按鈕按下事件
    @objc private func generateQRCodeButtonPressed() {
        guard let text = inputTextField.text, !text.isEmpty else {
            let alert = UIAlertController(
                title: "錯誤",
                message: "請輸入文本以生成二維碼",
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(
                    title: "確定",
                    style: .default,
                    handler: nil
                )
            )
            self.present(
                alert,
                animated: true,
                completion: nil
            )
            return
        }
        generateQRCode(
            withText: text
        )
    }
    
    // 設定點擊手勢方法
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(
                dismissKeyboard
            )
        )
        view.addGestureRecognizer(
            tapGesture
        )
    }
    
    // 隱藏鍵盤
    @objc func dismissKeyboard() {
        view.endEditing(
            true
        )
        generateQRCode(
            withText: inputTextField.text ?? ""
        )
    }
    
    // 生成二維碼
    public func generateQRCode(
        withText text: String
    ) {
        let doc = QRCode.Document(
            utf8String: text,
            errorCorrection: .high
        )
        
        qrCodeView.document = doc
        setupDefaultQRCodeDesign()
        qrCodeView.rebuildQRCode()
        
        addToHistory(
            result: text
        ) // 將生成的結果添加到歷史紀錄
    }
    
    // 添加到歷史紀錄的方法
    private func addToHistory(
        result: String
    ) {
        historyRecords.append(
            result
        )
        tableView.reloadData()
    }
    
    // 處理長按事件
    @objc func handleLongPress(
        gesture: UILongPressGestureRecognizer
    ) {
        if gesture.state == .began {
            guard let qrImage = self.qrCodeView.asImage() else {
                return
            }
            UIImageWriteToSavedPhotosAlbum(
                qrImage,
                self,
                #selector(
                    image(
                        _:didFinishSavingWithError:contextInfo:
                    )
                ),
                nil
            )
        }
    }
    
    // 處理圖片保存到相冊的回調
    @objc func image(
        _ image: UIImage,
        didFinishSavingWithError error: Error?,
        contextInfo: UnsafeRawPointer
    ) {
        if let error = error {
            let alert = UIAlertController(
                title: "錯誤",
                message: "保存圖片時出現錯誤：\(error.localizedDescription)",
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(
                    title: "確定",
                    style: .default,
                    handler: nil
                )
            )
            self.present(
                alert,
                animated: true,
                completion: nil
            )
        } else {
            let alert = UIAlertController(
                title: "成功",
                message: "圖片已保存到相冊。",
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(
                    title: "確定",
                    style: .default,
                    handler: nil
                )
            )
            self.present(
                alert,
                animated: true,
                completion: nil
            )
        }
    }
    
    // 返回按鈕按下時的處理
    @objc func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            let alert = UIAlertController(
                title: "錯誤",
                message: "請輸入文本以生成二維碼",
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(
                    title: "確定",
                    style: .default,
                    handler: nil
                )
            )
            self.present(
                alert,
                animated: true,
                completion: nil
            )
            return false
        }
        generateQRCode(
            withText: text
        )
        textField.resignFirstResponder()
        return true
    }
}

extension UIView {
    // 將UIView轉換為UIImage的方法
    func asImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            self.bounds.size,
            false,
            UIScreen.main.scale
        )
        defer {
            UIGraphicsEndImageContext()
        }
        self.drawHierarchy(
            in: self.bounds,
            afterScreenUpdates: true
        )
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension GenerateViewController: UITableViewDataSource, UITableViewDelegate {
    
    // 返回表格數據的行數
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return historyRecords.count
    }
    
    // 配置表格單元格
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath
        )
        cell.textLabel?.text = historyRecords[indexPath.row]
        cell.textLabel?.textColor = .darkGray
        cell.backgroundColor = UIColor(
            white: 0.95,
            alpha: 1
        ) // 淺灰色背景
        cell.selectionStyle = .none
        return cell
    }
    
    // 點擊表格單元格時的處理
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
    }
    
    // 視圖布局完成後設置表格視圖樣式
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layer.cornerRadius = 12
        tableView.layer.shadowColor = UIColor.gray.cgColor
        tableView.layer.shadowOpacity = 0.3
        tableView.layer.shadowOffset = CGSize(
            width: 0,
            height: 2
        )
        tableView.layer.shadowRadius = 4
    }
}
#endif
