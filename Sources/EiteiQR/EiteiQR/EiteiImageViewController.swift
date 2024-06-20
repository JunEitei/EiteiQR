//
//  EiteiImageViewController.swift
//  EiteiQR
//
//  Created by damao on 2024/6/18.
//
import UIKit

// 二維碼展示器
class EiteiImageViewController: UIViewController {
    
    var image: UIImage? // 用於接收外部傳入的圖片
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // 設置內容模式為縮放適配
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var initialTouchPoint: CGPoint = .zero // 手指初始觸摸點
    private var isDismissalInProgress = false // 標記是否正在進行關閉過程
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear // 設置視圖背景色為白色
        view.isUserInteractionEnabled = true // 允許用戶交互
        
        // 添加 imageView 並設置約束
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
        ])
        
        // 設置 imageView 的圖片
        if let image = image {
            imageView.image = image
        }
        
        // 添加滑動手勢識別器
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        
        // 添加點擊手勢識別器
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
        
        // 添加透明覆蓋視圖，點擊這個視圖也會關閉 ImageViewController
        view.addSubview(overlayView)
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        let overlayTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        overlayView.addGestureRecognizer(overlayTapGesture)
    }
    
    // 處理滑動手勢
    @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        
        switch gestureRecognizer.state {
        case .began:
            initialTouchPoint = gestureRecognizer.location(in: view)
        case .changed:
            if translation.y > 0 {
                let translationY = min(translation.y, 300) // 限制滑動距離最大為300點
                let progress = translationY / 300.0 // 計算滑動進度
                view.transform = CGAffineTransform(translationX: 0, y: translationY)
                view.alpha = 1 - progress // 根據滑動距離調整透明度
            }
        case .ended, .cancelled:
            let velocity = gestureRecognizer.velocity(in: view)
            let shouldDismiss = velocity.y > 500 || (gestureRecognizer.translation(in: view).y > view.bounds.height / 2)
            if shouldDismiss {
                dismissViewController()
            } else {
                resetViewPosition()
            }
        default:
            break
        }
    }
    
    // 處理點擊手勢
    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        dismissViewController()
    }
    
    // 關閉視圖控制器
    private func dismissViewController() {
        guard !isDismissalInProgress else { return }
        isDismissalInProgress = true
        UIView.animate(withDuration: 0.3, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
            self.view.alpha = 0
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // 重置視圖位置
    private func resetViewPosition() {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
            self.view.alpha = 1
        }
    }
}
