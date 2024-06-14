//
//  EiteiCheckmark.swift
//  EiteiQR
//
//  Created by damao on 2024/6/14.
//

import UIKit

open class EiteiCheckmark: UIControl {
    public static let minCheckmarkHeight: CGFloat = 20.0
    
    // 用來定義各個選項
    open var options: [CheckmarkOption] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // 設定動畫持續時間
    open var animationLength: CFTimeInterval = 0.4
    
    // 設定邊框顏色
    open var strokeColor: UIColor = UIColor.white {
        didSet {
            // 更新選項的邊框顏色
            options = options.map { CheckmarkOption(borderColor: self.strokeColor, fillColor: $0.fillColor) }
        }
    }
    
    // 設定線條寬度
    open var lineWidth: CGFloat = 3.0 {
        didSet {
            // 更新鉤子和圓形邊框的線條寬度
            self.checkmarkWidth = lineWidth * 2
            self.circleBorderLineWidth = lineWidth * 3
            setNeedsDisplay()
        }
    }
    
    // 設定選中的索引
    open var selectedIndex: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // 勾勾的粗細
    fileprivate var checkmarkWidth: CGFloat = 0
    
    // 邊框的粗細
    fileprivate var circleBorderLineWidth: CGFloat = 0
    
    // 初始化方法
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    fileprivate func setup() {
        contentMode = .redraw
        layer.masksToBounds = true
        lineWidth = 3.0
    }
    
    // 計算控件大小，考慮圓形間距和邊框寬度
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        let totalSpacing = CGFloat(options.count - 1) * 11
        let availableWidth = size.width - totalSpacing
        let sectionWidth = availableWidth / CGFloat(options.count)
        return CGSize(width: sectionWidth * CGFloat(options.count) + totalSpacing, height: EiteiCheckmark.minCheckmarkHeight)
    }
    
    // 繪製視圖，包含圓形和勾勾的動畫
    override open func draw(_ rect: CGRect) {
        let totalSpacing = CGFloat(options.count - 1) * 11
        let availableWidth = rect.width - totalSpacing
        let sectionWidth = availableWidth / CGFloat(options.count)
        
        self.layer.sublayers = nil
        
        //使用更精確的間距計算邏輯，確保每個圓形的寬度和間距正確
        for index in 0..<options.count {
            let option = options[index]
            let xOffset = CGFloat(index) * (sectionWidth + 11)
            let containerFrame = CGRect(x: xOffset, y: 0, width: sectionWidth, height: rect.height).integral
            let remainingContainerFrame = containerFrame.insetBy(dx: 0, dy: EiteiCheckmark.minCheckmarkHeight / 2).integral
            let borderLayer = createCircleLayer(remainingContainerFrame, option: option)
            layer.addSublayer(borderLayer)
            
            // 如果是選中的索引，添加動畫和勾勾
            if index == selectedIndex {
                animateCircleBorder(borderLayer)
                
                let tickLayer = createTick(borderLayer.frame, strokeColor: strokeColor)
                layer.addSublayer(tickLayer)
            }
        }
    }
    
    // 創建圓形層，設置圓形的邊框和填充顏色
    fileprivate func createCircleLayer(_ containerFrame: CGRect, option: CheckmarkOption) -> CAShapeLayer {
        let height = min(containerFrame.width, containerFrame.height)
        let xOffset = containerFrame.midX - height / 2
        let frame = CGRect(x: xOffset, y: 0, width: height, height: height)
        let cornerRadius = ceil(frame.height / 2)
        
        let borderLayer: CAShapeLayer = CAShapeLayer()
        borderLayer.frame = frame
        borderLayer.lineWidth = circleBorderLineWidth
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.backgroundColor = option.fillColor.cgColor
        borderLayer.cornerRadius = cornerRadius
        borderLayer.strokeColor = option.borderColor.cgColor
        borderLayer.strokeEnd = 0
        borderLayer.masksToBounds = true
        
        borderLayer.path = UIBezierPath(roundedRect: borderLayer.bounds, cornerRadius: cornerRadius).cgPath
        
        adjustScale(borderLayer)
        
        return borderLayer
    }
    
    // 創建勾勾圖層，設置勾勾的顏色和線條
    fileprivate func createTick(_ containerFrame: CGRect, strokeColor: UIColor) -> CAShapeLayer {
        let tickPath = UIBezierPath()
        
        // 手工繪製勾勾：確定起點
        tickPath.move(to: CGPoint(x: containerFrame.width * 0.25, y: containerFrame.height * 0.5))
        // 手工繪製勾勾：第一筆
        tickPath.addLine(to: CGPoint(x: containerFrame.width * 0.42, y: containerFrame.height * 0.65))
        // 手工繪製勾勾：第二筆
        tickPath.addLine(to: CGPoint(x: containerFrame.width * 0.7, y: containerFrame.height * 0.29))
        
        let tickLayer: CAShapeLayer = CAShapeLayer()
        tickLayer.frame = containerFrame
        tickLayer.lineWidth = checkmarkWidth
        tickLayer.strokeColor = strokeColor.cgColor
        tickLayer.fillColor = UIColor.clear.cgColor
        tickLayer.path = tickPath.cgPath
        
        adjustScale(tickLayer)
        
        return tickLayer
    }
    
    // 優化圖層性能，提高渲染效率
    fileprivate func adjustScale(_ layer: CALayer) {
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.contentsScale = UIScreen.main.scale
    }
    
    // 圓形邊框動畫，讓圓形邊框平滑顯示
    fileprivate func animateCircleBorder(_ layer: CAShapeLayer) {
        layer.strokeEnd = 1.0
        let animationKey = "strokeEnd"
        let animation: CABasicAnimation = CABasicAnimation(keyPath: animationKey)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.duration = animationLength
        animation.fromValue = 0.0
        animation.toValue = 1.0
        
        layer.add(animation, forKey: animationKey)
    }
    
    // 處理觸摸事件，更新選中的索引並通知代理
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        if bounds.contains(location) {
            let totalSpacing = CGFloat(options.count - 1) * 11
            let availableWidth = bounds.width - totalSpacing
            let sectionWidth = availableWidth / CGFloat(options.count)
            
            //將 location.x 减去總間距，以確保正確計算每個圓形的索引
            let index = Int((location.x - totalSpacing) / sectionWidth)
            
            // 檢查索引是否在範圍內
            if index >= 0 && index < options.count {
                selectedIndex = index
                sendActions(for: .valueChanged)
            }
        }
    }
}

// 公共方法
public struct CheckmarkOption {
    public let borderColor: UIColor
    public let fillColor: UIColor
    
    public init(borderColor: UIColor = UIColor.black, fillColor: UIColor = UIColor.lightGray) {
        self.borderColor = borderColor
        self.fillColor = fillColor
    }
}
