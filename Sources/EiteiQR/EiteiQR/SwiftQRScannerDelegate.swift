//
//  SwiftQRScannerDelegate.swift
//  SwiftQRScanner
//
//  Created by Vinod Jagtap on 27/04/22.
//

#if os(iOS)
import UIKit
import Foundation

/// A protocol that defines methods to be called when specific events occur during QR code scanning.
public protocol QRScannerCodeDelegate: AnyObject {
    
    /// This method is called when a QR code is successfully scanned.
    /// - Parameters:
    ///   - controller: The view controller that presented the QR code scanner.
    ///   - result: The decoded payload of the scanned QR code.
    func qrScanner(_ controller: UIViewController, didScanQRCodeWithResult result: String)
    
    /// This method is called when an error occurs during QR code scanning.
    /// - Parameters:
    ///   - controller: The view controller that presented the QR code scanner.
    ///   - error: The error that occurred during scanning.
    func qrScanner(_ controller: UIViewController, didFailWithError error: QRCodeError)
    
    /// This method is called when the QR code scanning is canceled.
    /// - Parameter controller: The view controller that presented the QR code scanner.
    func qrScannerDidCancel(_ controller: UIViewController)
}
#endif
