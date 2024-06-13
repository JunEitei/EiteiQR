//
//  EiteiSegmentedControl.swift
//  EiteiQR
//
//  Created by damao on 2024/6/13.
//

import UIKit
import EiteiQR

/// 一個自訂的分段控制元件，用於在不同選項之間切換
public class EiteiSegmentedControl: UIControl {
    
    // MARK: - Constants
    
    private let underlineHeight: CGFloat = 5
    private let underlineWidthRatio: CGFloat = 1.0 / 6.0
    private let bottomSpacing: CGFloat = 3
    private let textFontSize: CGFloat = 17.0 // 字體大小
    private let indicatorLeftOffset: CGFloat = 5 // 下劃線的左偏移量
    
    /// 堆疊視圖，用於容納所有按鈕
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    /// 下劃線視圖，顯示於所選按鈕的底部
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2.5 // 設置圓角半徑，為下劃線設置圓角
        return view
    }()
    
    /// 下劃線視圖的領導約束，用於控制其位置
    private var underlineViewLeadingConstraint: Constraint!
    
    /// 當前所選的按鈕，當其改變時觸發動畫和狀態更新
    private var selectedButton: UIButton? {
        didSet {
            guard let button = selectedButton else { return }
            
            // 更新按鈕的選擇狀態
            for view in stackView.arrangedSubviews {
                guard let button = view as? UIButton else { continue }
                button.isSelected = false
            }
            button.isSelected = true
            
            // 動畫更新下劃線位置
            if let buttonIndex = stackView.arrangedSubviews.firstIndex(of: button) {
                selectedIndex = buttonIndex
                sendActions(for: .valueChanged)
                
                // 設置動畫時長
                let animationDuration: TimeInterval = underlineView.frame == CGRect.zero ? 0 : 0.15
                UIView.animate(withDuration: animationDuration, animations: {
                    // 更新下劃線的位移，繼續向左偏移5個單位
                    self.underlineViewLeadingConstraint.update(offset: button.center.x - self.stackView.frame.origin.x - (self.stackView.frame.width / CGFloat(self.items.count)) / 2 - 15)
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    // MARK: - Public Properties
    
    /// 當前所選的索引
    public var selectedIndex = 0
    
    /// 分段控制元件的項目
    public var items: [String] = [] {
        didSet {
            removeStackViewSubviews()
            
            // 為每個項目添加 UIButton
            for title in items {
                let button = UIButton(type: .custom)
                button.translatesAutoresizingMaskIntoConstraints = false
                stackView.addArrangedSubview(button)
                setupButtonItem(button, withTitle: title)
            }
            
            // 初始化配置第一個按鈕
            if let button = stackView.arrangedSubviews.first as? UIButton {
                underlineView.snp.remakeConstraints { make in
                    make.bottom.equalTo(stackView.snp.bottom).offset(bottomSpacing) // 增加和文字的間距
                    self.underlineViewLeadingConstraint = make.leading.equalTo(button.snp.centerX).constraint
                    make.width.equalTo(button.snp.width).multipliedBy(underlineWidthRatio) // 設置寬度
                    make.height.equalTo(underlineHeight) // 設置高度
                }
                
                selectedButton = button
            }
        }
    }
    
    /// 下劃線顏色
    public var underlineColor = UIColor.blue {
        didSet {
            underlineView.backgroundColor = underlineColor
        }
    }
    
    /// 預設文本顏色
    public var textDefaultColor = UIColor.gray {
        didSet {
            updateButtonsAppearance()
        }
    }
    
    /// 選擇文本顏色
    public var textSelectedColor = UIColor.darkGray {
        didSet {
            updateButtonsAppearance()
        }
    }
    
    // MARK: - Lifecycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.white
        translatesAutoresizingMaskIntoConstraints = false
        
        // 添加堆疊視圖和下劃線視圖
        addSubview(stackView)
        addSubview(underlineView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        underlineView.snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.bottom).offset(bottomSpacing) // 增加和文字的間距
            self.underlineViewLeadingConstraint = make.leading.equalToSuperview().constraint
            make.width.equalTo(stackView.arrangedSubviews.first?.snp.width ?? 0).multipliedBy(underlineWidthRatio) // 設置寬度
            make.height.equalTo(underlineHeight) // 設置高度
        }
    }
    
    override public var isEnabled: Bool {
        didSet {
            stackView.arrangedSubviews.forEach({
                if let button = $0 as? UIButton {
                    button.isEnabled = isEnabled
                }
            })
        }
    }
    
    // MARK: - Setup
    
    /// 設置按鈕項目
    private func setupButtonItem(_ button: UIButton, withTitle title: String) {
        let normalAttrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: textFontSize),
                                                          .foregroundColor: textDefaultColor]
        let selectedAttrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: textFontSize),
                                                            .foregroundColor: textSelectedColor]
        
        button.setAttributedTitle(NSAttributedString(string: title, attributes: normalAttrs), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: title, attributes: selectedAttrs), for: .selected)
        button.backgroundColor = UIColor.clear
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    // MARK: - Private
    
    /// 移除堆疊視圖中的所有子視圖
    private func removeStackViewSubviews() {
        stackView.arrangedSubviews.forEach({
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        })
    }
    
    /// 按鈕被按下時觸發
    @objc private func buttonPressed(_ button: UIButton) {
        guard button != selectedButton else { return }
        selectedButton = button
    }
    
    /// 更新按鈕外觀
    private func updateButtonsAppearance() {
        for subview in stackView.arrangedSubviews {
            guard let button = subview as? UIButton else { continue }
            
            let normalAttrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: textFontSize),
                                                              .foregroundColor: textDefaultColor]
            let selectedAttrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: textFontSize),
                                                                .foregroundColor: textSelectedColor]
            
            button.setAttributedTitle(NSAttributedString(string: button.currentAttributedTitle?.string ?? "Undefined", attributes: normalAttrs), for: .normal)
            button.setAttributedTitle(NSAttributedString(string: button.currentAttributedTitle?.string ?? "Undefined", attributes: selectedAttrs), for: .selected)
        }
    }
}
