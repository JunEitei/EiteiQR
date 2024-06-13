//
//  HistoryCell.swift
//  EiteiQRScanner
//
//  Created by damao on 2024/6/13.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#555555")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue // 示例圖標背景色
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor(hex: "#303030")
        self.selectionStyle = .none
        
        contentView.addSubview(cardView)
        cardView.addSubview(iconImageView)
        cardView.addSubview(urlLabel)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(dateLabel)
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5) // 四邊邊距為5
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 60)) // 設置為方形
            make.top.equalTo(cardView).offset(7)
            make.leading.equalTo(cardView).offset(15)
        }
        
        urlLabel.snp.makeConstraints { make in
            make.top.equalTo(cardView).offset(15)
            make.leading.equalTo(iconImageView.snp.trailing).offset(15)
            make.trailing.equalTo(cardView).offset(-15)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(urlLabel.snp.bottom).offset(5)
            make.leading.equalTo(iconImageView.snp.trailing).offset(15)
            make.trailing.equalTo(cardView).offset(-15)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(descriptionLabel)
            make.trailing.equalTo(cardView).offset(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with url: String, subtitle: String, date: String) {
        urlLabel.text = url
        descriptionLabel.text = subtitle
        dateLabel.text = date
    }
}
