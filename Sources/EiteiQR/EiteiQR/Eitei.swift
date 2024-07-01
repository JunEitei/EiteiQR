//
//  Eitei.swift
//  EiteiQR
//
//  Created by damao on 2024/6/17.
//

import UIKit

// 這個類用來做一些關乎全局的事情
class Eitei {
    static let shared = Eitei()
    
    private init() { }
    
    // 封裝從Bundle中讀取圖片
    func loadImage(named name: String) -> UIImage? {
        
        // 获取 CocoaPods 资源 bundle
        guard let bundleURL = Bundle(for: Eitei.self).url(forResource: "Resource", withExtension: "bundle"),
              let bundle = Bundle(url: bundleURL) else {
            print("讀取bundle失敗")
            // 嘗試從文件夾裡直接讀取 （SPM）
            return UIImage(named: name)
        }
        // 通过 CocoaPods 封裝的 bundle 载入图片
        guard let image = UIImage(named: name, in: bundle, compatibleWith: nil) else {
            print("從 \(bundle)讀取圖片 \(name)失敗")
            return nil
        }
        return image
    }
    
    
}
