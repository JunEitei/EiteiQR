//
//  EiteiScanButton.swift
//  EiteiQR
//
//  Created by damao on 2024/6/13.
//

import UIKit

class EiteiScanButton: UIButton {
    
    private let hitAreaPadding: CGFloat = 500  // 扩展热区的距离，用于增加按钮的点击区域
    var onScanButtonTapped: (() -> Void)?  // 按钮点击事件的闭包，外部可以通过此闭包处理点击事件
    
    // 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()  // 设置按钮的外观和行为
    }
    
    // 必须实现的初始化方法，使用 fatalError 表示该方法不应被调用
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 设置按钮的外观和行为
    private func setupButton() {
        
        self.layer.cornerRadius = 55  // 设置按钮的圆角半径，使其为圆形
        self.layer.masksToBounds = true  // 允许子视图超出按钮边界
        
        // 创建并添加一个 UIImageView 用于显示扫描图标
        let scanImageView = UIImageView(image: Eitei.shared.loadImage(named: "scan"))
        scanImageView.contentMode = .scaleToFill  // 设置图片内容模式为按比例缩放以适应按钮
        self.addSubview(scanImageView)  // 将 UIImageView 添加到按钮视图中
        
        // 使用 SnapKit 设置 UIImageView 的约束，使其在按钮中心并且宽高为 90
        scanImageView.snp.makeConstraints { make in
            make.center.equalTo(self)  // UIImageView 位于按钮的中心
            make.width.height.equalTo(110)  // 设置宽度和高度
        }
        
        // 添加按钮点击事件的目标动作
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    // 按钮点击事件的处理方法
    @objc private func buttonTapped() {
        onScanButtonTapped?()  // 调用外部定义的点击事件处理闭包
    }
    
    // 重写 hitTest 方法以扩展按钮的点击区域
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 扩展按钮的边界，使点击区域增加 hitAreaPadding
        let expandedBounds = self.bounds.insetBy(dx: -hitAreaPadding, dy: -hitAreaPadding)
        // 如果点击点在扩展后的区域内，返回按钮自身；否则调用超类的 hitTest 方法
        return expandedBounds.contains(point) ? self : super.hitTest(point, with: event)
    }
    
}
