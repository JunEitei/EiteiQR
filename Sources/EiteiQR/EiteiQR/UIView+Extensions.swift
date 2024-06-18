//
//  UIView+Extensions.swift
//  EiteiQR
//
//  Created by damao on 2024/6/18.
//

import UIKit

// 擴展View以便將其轉換為UIImage
extension UIView {
    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
