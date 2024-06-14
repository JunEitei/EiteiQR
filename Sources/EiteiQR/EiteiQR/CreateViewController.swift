//
//  CreatorViewController.swift
//  EiteiQR
//
//  Created by damao on 2024/6/14.
//

import UIKit

public class CreatorViewController: UIViewController {
    
    // 顯示標題的Label
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Web QR Code"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    // 顯示圖標的ImageView，恢復之前的大小
    let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "iconImage"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 顯示QR碼的ImageView
    let qrImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "QRImage"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 文本框，顯示預設網址，並設置樣式
    let urlTextField: UITextField = {
        let textField = UITextField()
        textField.text = "https://www.google.com.tw"
        textField.borderStyle = .none
        textField.textColor = .white
        textField.backgroundColor = .eiteiLightGray
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.keyboardAppearance = .dark
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
            CheckmarkOption(borderColor: UIColor.white, fillColor: UIColor.red),
            CheckmarkOption(borderColor: UIColor.white, fillColor: UIColor.orange),
            CheckmarkOption(borderColor: UIColor.white, fillColor: UIColor.yellow),
            CheckmarkOption(borderColor: UIColor.white, fillColor: UIColor.green),
            CheckmarkOption(borderColor: UIColor.white, fillColor: UIColor.blue)
        ]
        control.selectedIndex = 0
        control.addTarget(nil, action: #selector(checkmarkControlValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapGesture()
    }
    
    private func setupUI() {
        view.backgroundColor = .eiteiBackground
        
        // 添加UI組件
        view.addSubview(titleLabel)
        view.addSubview(iconImageView)
        view.addSubview(qrImageView)
        view.addSubview(urlCardView)
        urlCardView.addSubview(urlTextField)
        view.addSubview(colorCardView)
        colorCardView.addSubview(checkmarkControl)
        
        // 設置標題Label的約束
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // 設置圖標ImageView的約束，恢復之前的大小
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        // 設置QR碼ImageView的約束
        qrImageView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 200))
        }
        
        // 設置網址卡片的約束
        urlCardView.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(50)  // 減小高度
        }
        
        // 設置文本框的約束
        urlTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        // 設置顏色卡片的約束
        colorCardView.snp.makeConstraints { make in
            make.top.equalTo(urlCardView.snp.bottom).offset(20)
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
    }
    
    // 添加點擊手勢來收起鍵盤
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // 點擊空白處收起鍵盤
    @objc private func dismissKeyboard() {
        urlTextField.resignFirstResponder()
    }
    
    // 勾勾控制元件選擇變化時的處理方法
    @objc private func checkmarkControlValueChanged(_ sender: EiteiCheckmark) {
        let selectedOption = sender.options[sender.selectedIndex]
        // 在這裡添加選擇變化的處理邏輯
    }
}
