//
//  UIColor+Hex.swift
//  EiteiQR
//
//  Created by damao on 2024/6/13.
//

// MARK: - UIColor Extension

import UIKit

extension UIColor {
    // 使用十六进制字符串初始化 UIColor 实例
    convenience init(hex: String) {
        // 去除字符串前后的空白字符，并将字符串转换为大写
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // 如果字符串以 "#" 开头，则移除它
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        // 如果字符串的长度不是 6，则返回默认灰色颜色
        if hexString.count != 6 {
            self.init(white: 0.5, alpha: 1.0)
            return
        }
        
        // 将十六进制字符串转换为 UInt64 类型的整数值
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        // 从整数值中提取红色、绿色和蓝色分量
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        // 使用提取的 RGB 分量初始化 UIColor 实例
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
