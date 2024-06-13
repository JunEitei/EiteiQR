//
//  HistoryCell.swift
//  EiteiQR
//
//  Created by damao on 2024/6/13.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    // MARK: - Views
    
    // 卡片视图，作为单元格的背景
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#555555") // 设置背景颜色为深灰色
        view.layer.cornerRadius = 10 // 设置圆角
        view.clipsToBounds = true // 超出部分裁剪
        return view
    }()
    
    // 图标视图，显示二维码或相关图标
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10 // 设置圆角
        imageView.clipsToBounds = true // 超出部分裁剪
        
        return imageView
    }()
    
    // URL 标签，显示URL的文本
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold) // 设置字体为加粗的16号
        label.textColor = .white // 设置文字颜色为白色
        return label
    }()
    
    // 描述标签，显示简短描述文本
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular) // 设置字体为常规的14号
        label.textColor = .lightGray // 设置文字颜色为浅灰色
        return label
    }()
    
    // 日期标签，显示日期信息
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular) // 设置字体为常规的12号
        label.textColor = .gray // 设置文字颜色为灰色
        return label
    }()
    
    // MARK: - Initialization
    
    // 初始化单元格
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 设置单元格背景色
        self.contentView.backgroundColor = UIColor(hex: "#303030")
        self.selectionStyle = .none // 设置选中样式为无
        
        // 将子视图添加到 contentView
        contentView.addSubview(cardView)
        cardView.addSubview(iconImageView)
        cardView.addSubview(urlLabel)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(dateLabel)
        
        // 设置卡片视图的约束
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5) // 四边边距为5
        }
        
        // 设置图标视图的约束
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 60)) // 设置图标为方形
            make.top.equalTo(cardView).offset(7) // 上边距为7
            make.leading.equalTo(cardView).offset(15) // 左边距为15
        }
        
        // 设置URL标签的约束
        urlLabel.snp.makeConstraints { make in
            make.top.equalTo(cardView).offset(15) // 上边距为15
            make.leading.equalTo(iconImageView.snp.trailing).offset(15) // 左边距为图标视图右侧的15
            make.trailing.equalTo(cardView).offset(-15) // 右边距为-15
        }
        
        // 设置描述标签的约束
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(urlLabel.snp.bottom).offset(5) // 上边距为URL标签底部的5
            make.leading.equalTo(iconImageView.snp.trailing).offset(15) // 左边距为图标视图右侧的15
            make.trailing.equalTo(cardView).offset(-15) // 右边距为-15
        }
        
        // 设置日期标签的约束
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(descriptionLabel) // 垂直居中于描述标签
            make.trailing.equalTo(cardView).offset(-15) // 右边距为-15
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    // 配置单元格内容的方法
    func configure(with url: String, subtitle: String, date: String) {
        urlLabel.text = url // 设置URL标签文本
        descriptionLabel.text = subtitle // 设置描述标签文本
        dateLabel.text = date // 设置日期标签文本
        
        // 设置随机颜色给图标，调用生成随机颜色的函数
        iconImageView.backgroundColor = generateRandomColor()
        
        // 按鈕圖標取決於二維碼內容是否為URL
        iconImageView.image = UIImage(named: isValidURL(url) ? "icon_website" : "icon_text")
        
    }
    
    // MARK: - Helpers
    
    
    // 判斷是否是URL
    private func isValidURL(_ string: String) -> Bool {
        guard let url = URL(string: string) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    /// 生成随机颜色，确保颜色不会太亮
    private func generateRandomColor() -> UIColor {
        let red = CGFloat.random(in: 0.3...0.7) // 随机生成红色值
        let green = CGFloat.random(in: 0.3...0.7) // 随机生成绿色值
        let blue = CGFloat.random(in: 0.3...0.7) // 随机生成蓝色值
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
