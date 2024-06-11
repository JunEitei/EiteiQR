//
//  RoundButton.swift
//  SwiftQRScanner
//
//  Created by Vinod Jagtap on 22/05/22.
//

#if os(iOS)
import Foundation
import UIKit

class RoundButton: UIButton {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton()
    }
    
    // MARK: - Configuration
    
    private func configureButton() {
        tintColor = .white
        backgroundColor = .black.withAlphaComponent(0.5)
        contentMode = .scaleAspectFit
        setRoundedCorners()
    }
    
    private func setRoundedCorners() {
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setRoundedCorners()
    }
}

// CloseButton is a subclass of UIButton that displays a cross (X) symbol on the button.
internal class CloseButton: UIButton {

    // Private property to hold the CAShapeLayer that draws the cross shape.
    private let crossLayer = CAShapeLayer()

    // Overridden initializer for creating instances from code.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCrossButton()
    }

    // Required initializer for creating instances from Interface Builder or Storyboard.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCrossButton()
    }

    // Private method to set up the initial properties of the crossLayer.
    private func setupCrossButton() {
        crossLayer.lineWidth = 2.0 // Set the line width of the cross
        crossLayer.strokeColor = UIColor.white.cgColor // Set the stroke color of the cross
        crossLayer.fillColor = UIColor.clear.cgColor // Set the fill color of the cross (transparent)
        layer.addSublayer(crossLayer) // Add the crossLayer as a sublayer to the button's layer
    }

    // Overridden layoutSubviews method to update the path of the cross shape based on the button's bounds.
    override func layoutSubviews() {
        super.layoutSubviews()

        // Create a new UIBezierPath to define the cross shape.
        let path = UIBezierPath()

        // Move the path's starting point to the top-right corner of the button's bounds.
        path.move(to: CGPoint(x: bounds.width, y: bounds.height))

        // Add a line from the top-right corner to the bottom-left corner.
        path.addLine(to: CGPoint(x: bounds.width - bounds.width, y: bounds.height - bounds.height))

        // Move the path's starting point to the bottom-left corner.
        path.move(to: CGPoint(x: bounds.width - bounds.width, y: bounds.height))

        // Add a line from the bottom-left corner to the top-right corner.
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height - bounds.height))

        // Set the path of the crossLayer to the newly created path.
        crossLayer.path = path.cgPath

        // Set the position of the crossLayer to the origin of the button's bounds.
        crossLayer.position = CGPoint(x: bounds.minX, y: bounds.minY)
    }
}

#endif
