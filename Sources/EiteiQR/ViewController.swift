//  ViewController.swift
//  EiteiQR
//
//  Created by damao on 2024/6/11.
//

#if canImport(UIKit)
import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 註冊其他自定義邏輯，例如設置 TabBar 預設屬性
        let generateViewController = GenerateViewController()
        generateViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "qrcode.viewfinder"), tag: 1) // 使用系統自帶的 QRCode 圖標
        
        let scanViewController = ScanViewController()
        scanViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "plus"), tag: 0) // 使用系統自帶的 "+" 圖標

        // 將 ViewControllers 添加到 TabBarController
        viewControllers = [generateViewController, scanViewController]

        // 设置视图控制器数组
        viewControllers = [generateViewController, scanViewController]
        
        // 配置 TabBar 的一些基本样式
        tabBar.tintColor = .white
        tabBar.barTintColor = .black
        tabBar.backgroundColor = .black
        
    }

}

#endif
