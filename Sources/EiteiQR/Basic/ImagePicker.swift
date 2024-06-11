//
//  ImagePicker.swift
//  SwiftQRScanner
//
//  Created by Vinod Jagtap on 15/05/22.
//

#if os(iOS)
import Foundation
import UIKit
import PhotosUI

/// A protocol that defines the delegate method for handling the selected image.
public protocol ImagePickerDelegate: AnyObject {
    /// Called when an image is selected from the image picker.
    ///
    /// - Parameter image: The selected image, or nil if no image was selected.
    func didSelect(image: UIImage?)
}

/// A class that provides a system-provided interface for selecting an image from the camera roll or photo library.
class PhotoPicker: NSObject {
    
    // The image picker controller used to present the system interface.
    private let pickerController: UIImagePickerController
    
    // A weak reference to the view controller that presents the image picker.
    private weak var presentationController: UIViewController?
    
    // A weak reference to the delegate that will handle the selected image.
    private weak var delegate: ImagePickerDelegate?
    
    /// Initializes a new instance of the `PhotoPicker` class.
    ///
    /// - Parameters:
    ///   - presentationController: The view controller that will present the image picker.
    ///   - delegate: The delegate that will handle the selected image.
    public init(presentationController: UIViewController,
                delegate: ImagePickerDelegate) {
        
        self.pickerController = UIImagePickerController()
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
    }
    
    /// Presents the image picker interface from the specified source view.
    ///
    /// - Parameter sourceView: The view from which the image picker should be presented.
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraRollAction = UIAlertAction(title: "Camera roll", style: .default) { [unowned self] _ in
            self.pickerController.sourceType = .savedPhotosAlbum
            presentationController?.present(self.pickerController, animated: true)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default) { [unowned self] _ in
            self.pickerController.sourceType = .photoLibrary
            presentationController?.present(self.pickerController, animated: true)
        }
        [cameraRollAction, photoLibraryAction].forEach { action in
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        self.presentationController?.present(alertController, animated: true)
    }
    
    // A private method that handles the selected image and notifies the delegate.
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension PhotoPicker: UIImagePickerControllerDelegate {
    
    /// Called when the image picker is canceled.
    ///
    /// - Parameter picker: The image picker controller that was canceled.
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    /// Called when an image has been selected from the image picker.
    ///
    /// - Parameters:
    ///   - picker: The image picker controller that selected the image.
    ///   - info: A dictionary containing information about the selected media.
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

// MARK: - UINavigationControllerDelegate

extension PhotoPicker: UINavigationControllerDelegate {}

// MARK: - PHPhotoPicker (Available on iOS 14 and later)

@available(iOS 14, *)
extension PHPhotoPicker: UINavigationControllerDelegate {}

/// A class that provides an interface for selecting an image using the Photos UI on iOS 14 and later.
@available(iOS 14, *)
class PHPhotoPicker: NSObject {
    
    // The Photos UI picker controller used to present the interface.
    private let pickerController: PHPickerViewController
    
    // A weak reference to the view controller that presents the Photos UI picker.
    private weak var presentationController: UIViewController?
    
    // A weak reference to the delegate that will handle the selected image.
    private weak var delegate: ImagePickerDelegate?
    
    /// Initializes a new instance of the `PHPhotoPicker` class.
    ///
    /// - Parameters:
    ///   - presentationController: The view controller that will present the Photos UI picker.
    ///   - delegate: The delegate that will handle the selected image.
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        var phPickerConfiguration = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfiguration.selectionLimit = 1
        phPickerConfiguration.filter = .images
        self.pickerController = PHPickerViewController(configuration: phPickerConfiguration)
        super.init()
        self.pickerController.delegate = self
        self.presentationController = presentationController
        self.delegate = delegate
    }
    
    /// Requests authorization to access the photo library and presents the Photos UI picker if authorized.
    public func present() {
        PHPhotoLibrary.requestAuthorization({ (newStatus) in
            DispatchQueue.main.async {
                if newStatus ==  PHAuthorizationStatus.authorized {
                    self.presentationController?.present(self.pickerController,
                                                         animated: true)
                }
            }
        })
    }
}

// MARK: - PHPickerViewControllerDelegate

@available(iOS 14, *)
extension PHPhotoPicker: PHPickerViewControllerDelegate {
    
    /// Called when an image has been selected from the Photos UI picker.
    ///
    /// - Parameters:
    ///   - picker: The Photos UI picker controller that selected the image.
    ///   - results: An array of `PHPickerResult` objects representing the selected images.
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.delegate?.didSelect(image: image)
                    }
                }
            })
        }
    }
}

#endif
