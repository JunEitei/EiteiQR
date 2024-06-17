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

    func loadImage(named name: String) -> UIImage? {
        guard let bundlePath = Bundle(for: type(of: self)).path(forResource: "EiteiQRAssets", ofType: "bundle"),
              let assetBundle = Bundle(path: bundlePath) else {
            print("Failed to locate bundle or asset bundle path")
            return nil
        }

        let imagePath = assetBundle.path(forResource: name, ofType: nil)
        print("Attempting to load image: \(name) from bundle: \(assetBundle.bundlePath), image path: \(String(describing: imagePath))")

        if let image = UIImage(named: name, in: assetBundle, compatibleWith: nil) {
            print("Image \(name) loaded successfully")
            return image
        } else {
            print("Failed to load image \(name)")
            return nil
        }
    }
}
