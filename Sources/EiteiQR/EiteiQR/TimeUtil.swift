//
//  TimeUtil.swift
//  EiteiQR
//
//  Created by damao on 2024/6/13.
//

import Foundation

class TimeUtil {
    
    /// 获取当前时间的字符串格式，格式为 "HH:mm:ss"
    static func getCurrentTimeString() -> String {
        // 获取当前日期和时间
        let currentDate = Date()
        
        // 创建日历实例
        let calendar = Calendar.current
        
        // 使用日历提取当前时间的小时、分钟和秒
        let hour = calendar.component(.hour, from: currentDate)
        let minute = calendar.component(.minute, from: currentDate)
        let second = calendar.component(.second, from: currentDate)
        
        // 格式化为字符串
        let timeString = String(format: "%02d:%02d:%02d", hour, minute, second)
        
        return timeString
    }
}
