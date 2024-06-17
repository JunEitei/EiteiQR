//
//  CreatorViewController.swift
//  EiteiQR
//
//  Created by damao on 2024/6/14.
//

import UIKit

public class CreatorViewController: UIViewController, UITextFieldDelegate {
    
    // 設置代理的引用。以便當視圖消失時，調用代理方法將數據回傳
    weak var delegate: CreatorViewControllerDelegate?
    
    // 顯示標題的Label
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Web QR Code"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    // 顯示圖標的ImageView
    let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_website"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear // 初始背景色
        imageView.layer.cornerRadius = 20 // 圓角處理
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // 顯示QR碼的QRCodeView
    var qrCodeView: QRCodeView = {
        let view = QRCodeView()
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.isHidden = true // 初始隐藏
        return view
    }()
    
    // 白色背景View
    let qrBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 17  // 添加圓角
        view.layer.masksToBounds = true
        return view
    }()
    
    // 文本框，顯示預設網址，並設置樣式
    let urlTextField: UITextField = {
        let textField = UITextField()
        textField.text = ""
        textField.borderStyle = .none
        textField.textColor = .white
        textField.backgroundColor = .eiteiLightGray
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.keyboardAppearance = .dark
        textField.returnKeyType = .done
        textField.placeholder = "Enter Website URL"
        return textField
    }()
    
    // 顯示網址的卡片
    let urlCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .eiteiLightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    // 顯示選擇顏色的卡片
    let colorCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .eiteiLightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    // 自定義的勾勾控制元件
    let checkmarkControl: EiteiCheckmark = {
        let control = EiteiCheckmark()
        control.options = [
            CheckmarkOption(borderColor: .white, fillColor: .eiteiRed),
            CheckmarkOption(borderColor: .white, fillColor: .eiteiSuperOrange),
            CheckmarkOption(borderColor: .white, fillColor: .eiteiYellow),
            CheckmarkOption(borderColor: .white, fillColor: .eiteiGreen),
            CheckmarkOption(borderColor: .white, fillColor: .eiteiBlue)
        ]
        control.selectedIndex = 0
        control.addTarget(nil, action: #selector(checkmarkControlValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    // 顯示 "Website URL"
    let websiteLabel: UILabel = {
        let label = UILabel()
        label.text = "Website URL"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    // 顯示 "Color"
    let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Color"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    // 保存按鈕
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon_download"), for: .normal)
        button.tintColor = .white
        button.addTarget(nil, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 虚线框
    let dashedBorderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        //半透明效果
        layer.strokeColor = UIColor.eiteiLightGray.withAlphaComponent(0.5).cgColor
        layer.lineDashPattern = [4, 2]
        layer.fillColor = nil
        layer.lineWidth = 2
        return layer
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapGesture()
        
        // 設置文本輸入代理
        urlTextField.delegate = self
        
        // 初始化图标颜色
        iconImageView.backgroundColor = .eiteiYellow // 设置默认颜色
        // 註冊鍵盤通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        // 巧用icon
        let selectedColorHexString = iconImageView.backgroundColor?.toHexString()
        // 获取当前日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = dateFormatter.string(from: Date())
        
        // 如果 URL 是空的，則不進行任何操作
        
        guard let urlText = urlTextField.text, !urlText.isEmpty else {
            return
        }
        
        // 如果有文字內容再回傳
        delegate?.didSaveQRCode(url: urlTextField.text!, color: selectedColorHexString!, date: currentDate)
    }
    
    // 判斷是否是URL
    private func isValidURL(_ string: String) -> Bool {
        guard let url = URL(string: string) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    
    deinit {
        // 移除鍵盤通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dashedBorderLayer.path = UIBezierPath(roundedRect: qrBackgroundView.bounds.insetBy(dx: 5, dy: 5), cornerRadius: 17).cgPath
    }
    
    private func setupUI() {
        view.backgroundColor = .eiteiBackground
        
        // 添加UI組件
        view.addSubview(titleLabel)
        view.addSubview(iconImageView)
        view.addSubview(qrBackgroundView)  // 添加白色背景View
        qrBackgroundView.addSubview(qrCodeView)
        qrBackgroundView.layer.addSublayer(dashedBorderLayer) // 添加虚线框
        view.addSubview(websiteLabel)  // 添加Website URL的Label
        view.addSubview(urlCardView)
        urlCardView.addSubview(urlTextField)
        view.addSubview(colorLabel)    // 添加Color的Label
        view.addSubview(colorCardView)
        colorCardView.addSubview(checkmarkControl)
        view.addSubview(saveButton) // 添加保存按鈕
        
        // 設置標題Label的約束
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // 標題之外所有其他控件總體垂直偏移量
        let topOffset = 40
        // 標題之外所有其他控件平均間距
        let spaceBetween: CGFloat = 25
        
        // 設置圖標ImageView的約束
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(topOffset)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        // 設置QR碼QRCodeView的約束
        qrBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(spaceBetween)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(184)
        }
        
        qrCodeView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)  // 內邊距5
        }
        
        // 設置Website Label的約束
        websiteLabel.snp.makeConstraints { make in
            make.top.equalTo(qrBackgroundView.snp.bottom).offset(spaceBetween)
            make.leading.equalTo(urlCardView.snp.leading).offset(10)
        }
        
        // 設置網址卡片的約束
        urlCardView.snp.makeConstraints { make in
            make.top.equalTo(websiteLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(50)
        }
        
        // 設置文本框的約束
        urlTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        // 設置Color Label的約束
        colorLabel.snp.makeConstraints { make in
            make.top.equalTo(urlCardView.snp.bottom).offset(spaceBetween)
            make.leading.equalTo(colorCardView.snp.leading).offset(10)
        }
        
        // 設置顏色卡片的約束
        colorCardView.snp.makeConstraints { make in
            make.top.equalTo(colorLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(urlCardView)
            make.height.equalTo(75)
        }
        
        // 設置勾勾控制元件的約束
        checkmarkControl.snp.makeConstraints { make in
            make.top.equalTo(colorCardView.snp.top).offset(10)
            make.leading.equalTo(colorCardView.snp.leading).offset(10)
            make.trailing.equalTo(colorCardView.snp.trailing).offset(-10)
            make.bottom.equalTo(colorCardView.snp.bottom).offset(-10)
        }
        
        // 設置保存按鈕的約束，與Title水平對齊
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(2)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-7)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
    }
    
    // 添加點擊手勢來收起鍵盤
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // 點擊空白處收起鍵盤並生成QRCode
    @objc private func dismissKeyboard() {
        urlTextField.resignFirstResponder()
        generateQRCode()
    }
    
    // 處理返回鍵點擊事件
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        generateQRCode()
        return true
    }
    
    // 生成QRCode的方法
    private func generateQRCode() {
        guard let urlString = urlTextField.text, let url = URL(string: urlString), !urlString.isEmpty else {
            qrCodeView.isHidden = true
            dashedBorderLayer.isHidden = false
            return
        }
        let doc = QRCode.Document(
            url,
            errorCorrection: .high
        )
        qrCodeView.document = doc
        qrCodeView.rebuildQRCode()
        qrCodeView.isHidden = false
        dashedBorderLayer.isHidden = true
    }
    
    // 處理勾選控制元件值變更事件
    @objc private func checkmarkControlValueChanged(_ sender: EiteiCheckmark) {
        let selectedOption = sender.options[sender.selectedIndex]
        
        
        qrCodeView.tintColor = selectedOption.fillColor
        iconImageView.backgroundColor = selectedOption.fillColor  // 更新圖標背景色
    }
    
    // 炸裂效果動畫
    private func animateSaveButtonExplosion(completion: @escaping () -> Void) {
        let saveButton = self.saveButton
        
        // 動畫持續時間
        let duration: TimeInterval = 0.4
        
        // 執行動畫
        UIView.animate(withDuration: duration / 2, animations: {
            // 按鈕放大並淡出
            saveButton.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
            saveButton.alpha = 0.5
        }, completion: { _ in
            // 還原按鈕大小並淡入
            UIView.animate(withDuration: duration / 2, animations: {
                saveButton.transform = CGAffineTransform.identity
                saveButton.alpha = 1.0
            }, completion: { _ in
                // 動畫完成後調用完成處理程序
                completion()
            })
        })
    }
    
    
    // 保存按鈕點擊事件
    @objc private func saveButtonTapped() {
        
        // 先執行炸裂效果動畫
        animateSaveButtonExplosion { [weak self] in
            // 確保 QR Code 圖像轉換成功
            guard let self = self, let qrCodeImage = self.qrCodeView.asImage() else { return }
            // 保存圖像到相冊
            UIImageWriteToSavedPhotosAlbum(qrCodeImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
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
    
    // 鍵盤顯示事件
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        
        // 移動視圖以便textField不被遮擋
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -keyboardHeight
        }
    }
    
    // 鍵盤隱藏事件
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
}

// 擴展QRCodeView以便將其轉換為UIImage
extension UIView {
    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
