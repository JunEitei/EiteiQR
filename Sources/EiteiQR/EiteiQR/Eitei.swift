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
#if SWIFT_PACKAGE
            let bundle = Bundle.module
            
            // 這裡假設圖片是 PNG 格式，可以根據實際情況調整 withExtension 的參數
            if let imageUrl = bundle.url(forResource: name, withExtension: nil, subdirectory: "Resource"),
               let image = UIImage(contentsOfFile: imageUrl.path) {
                // 使用 image
                return image
            } else {
                // 如果找不到圖片，可以返回默認圖片或者報錯
                return UIImage(named: name)
            }
        }
#endif
        return nil
        
    }
    // 通过 CocoaPods 封裝的 bundle 载入图片
    guard let image = UIImage(named: name, in: bundle, compatibleWith: nil) else {
        print("從 \(bundle)讀取圖片 \(name)失敗")
        return nil
    }
    return image
}


}
