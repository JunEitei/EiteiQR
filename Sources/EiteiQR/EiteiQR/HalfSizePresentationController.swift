//
//  HalfSizePresentationController.swift
//  EiteiQR
//
//  Created by damao on 2024/6/18.
//

import UIKit

// 用於實現半屏顯示的過渡效果
class HalfSizePresentationController: UIPresentationController {
    
    
    // 計算展示視圖的邊界，設置為容器視圖中心的半屏大小
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return .zero
        }
        let width = containerView.bounds.width * 1 // 設置展示視圖的寬度為容器寬度的多少
        let height = containerView.bounds.height * 1 // 設置展示視圖的高度為容器高度的多少
        let originX = (containerView.bounds.width - width) / 2 // 計算x坐標，使展示視圖在水平方向上居中
        let originY = (containerView.bounds.height - height) / 2 // 計算y坐標，使展示視圖在垂直方向上居中
        return CGRect(x: originX, y: originY, width: width, height: height)
    }
    
    // 即將開始展示過渡動畫時調用
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }
        
        // 創建一個遮罩視圖，背景色為半透明黑色
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmingView.alpha = 0 // 初始透明度為0
        containerView.addSubview(dimmingView)
        
        // 過渡協調器，動畫顯示遮罩視圖
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            dimmingView.alpha = 1
        }, completion: nil)
    }
    
    // 即將開始隱藏過渡動畫時調用
    override func dismissalTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }
        
        // 找到遮罩視圖
        let dimmingView = containerView.subviews.first(where: { $0.backgroundColor == UIColor.black.withAlphaComponent(0.4) })
        
        // 過渡協調器，動畫隱藏遮罩視圖
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            dimmingView?.alpha = 0
        }, completion: { _ in
            dimmingView?.removeFromSuperview() // 完成過渡後，移除遮罩視圖
        })
    }
}
