//
//  UIImage+Extension.swift
//  SwiftQRScanner
//
//  Created by Vinod Jagtap on 23/05/22.
//

#if os(iOS)
import Foundation
import UIKit

extension UIImage {
    
    /// Parses a QR code from the current image and returns its payload as a `String`.
    ///
    /// This method uses CoreImage to detect and decode any QR codes present in the image. If multiple QR codes are found, it returns the payload of the first one.
    ///
    /// - Returns: The payload of the first detected QR code as a `String`, or `nil` if no QR code is found or an error occurs during the detection process.
    func parseQRCode() -> String? {
        // Create a CoreImage representation of the UIImage
        guard let ciImage = CIImage(image: self) else {
            return nil
        }
        
        // Set options for the QR code detector
        let detectorOptions = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        
        // Create a QR code detector with the specified options
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: detectorOptions),
              // Use the detector to find QR code features in the image
              let features = detector.features(in: ciImage) as? [CIQRCodeFeature],
              // Extract the payload of the first detected QR code
              let payload = features.compactMap({ $0.messageString }).first
        else {
            return nil
        }
        
        // Return the payload of the first detected QR code
        return payload
    }
}
#endif

