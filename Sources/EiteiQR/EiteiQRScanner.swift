//
//  EiteiQRScanner.swift
//  EiteiQRScanner
//
//  Created by damao on 2024/6/6.
//

#if os(iOS)
import UIKit
import CoreGraphics
import AVFoundation


/**
 QRCodeScannerController 是一個視圖控制器，會調用一個方法，呈現包含 AVCaptureSession 和 previewLayer 的視圖來掃描 QR 和其他代碼。
 */
public class QRCodeScannerController: UIViewController,
                                      UIImagePickerControllerDelegate,
                                      UINavigationBarDelegate {
    
    // 弱引用的代理，用於處理掃描到的代碼
    public weak var delegate: QRScannerCodeDelegate?
    
    // QR 掃描器的配置
    public var qrScannerConfiguration: QRScannerConfiguration
    
    // 用於切換閃光燈的按鈕
    private var flashButton: UIButton?
    
    // 默認屬性
    private let spaceFactor: CGFloat = 16.0 // 設置佈局的間距因子
    private let devicePosition: AVCaptureDevice.Position = .back // 默認相機位置（後置相機）
    private var _delayCount: Int = 0 // 儲存本地延遲計數
    private let delayCount: Int = 15 // 最大延遲計數
    private let roundButtonHeight: CGFloat = 50.0 // 圓形按鈕的高度
    private let roundButtonWidth: CGFloat = 50.0 // 圓形按鈕的寬度
    
    var photoPicker: NSObject? // 用於呈現照片選擇器（PHPhotoPicker 或 PhotoPicker）
    
    // 初始化捕獲設備
    private lazy var defaultDevice: AVCaptureDevice? = {
        // 獲取默認的視頻捕獲設備
        if let device = AVCaptureDevice.default(for: .video) {
            return device
        }
        return nil
    }()
    
    // 初始化前置捕獲設備
    private lazy var frontDevice: AVCaptureDevice? = {
        if #available(iOS 10, *) {
            // 獲取前置廣角相機（iOS 10 及以上版本）
            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                return device
            }
        } else {
            // 對於較舊的版本，遍歷可用的視頻設備，找到前置相機
            for device in AVCaptureDevice.devices(for: .video) {
                if device.position == .front { return device }
            }
        }
        return nil
    }()
    
    // 初始化 AVCaptureInput，使用 defaultDevice
    private lazy var defaultCaptureInput: AVCaptureInput? = {
        if let captureDevice = defaultDevice {
            do {
                // 創建一個 AVCaptureDeviceInput，使用默認設備
                return try AVCaptureDeviceInput(device: captureDevice)
            } catch let error as NSError {
                printLog(error.localizedDescription)
            }
        }
        return nil
    }()
    
    // 初始化 AVCaptureInput，使用 frontDevice
    private lazy var frontCaptureInput: AVCaptureInput? = {
        if let captureDevice = frontDevice {
            do {
                // 創建一個 AVCaptureDeviceInput，使用前置設備
                return try AVCaptureDeviceInput(device: captureDevice)
            } catch let error as NSError {
                printLog(error.localizedDescription)
            }
        }
        return nil
    }()
    
    private let dataOutput = AVCaptureMetadataOutput() // 用於捕獲元數據的輸出（例如，QR代碼）
    private let captureSession = AVCaptureSession() // 捕獲會話，用於視頻捕獲
    
    // 初始化 videoPreviewLayer，與捕獲會話相關聯
    private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill // 設置預覽層的視頻重力
        layer.cornerRadius = 10.0 // 設置預覽層的圓角半徑
        return layer
    }()
    
    // 使用 QRScannerConfiguration 初始化
    public init(qrScannerConfiguration: QRScannerConfiguration = .default) {
        self.qrScannerConfiguration = qrScannerConfiguration
        super.init(nibName: nil, bundle: nil)
        
        // 根據 iOS 版本初始化 photoPicker
        if #available(iOS 14, *) {
            photoPicker = PHPhotoPicker(presentationController: self, delegate: self) as PHPhotoPicker
        } else {
            photoPicker = PhotoPicker(presentationController: self, delegate: self) as PhotoPicker
        }
    }
    
    // 必須的便利初始化，適用於 storyboard 初始化
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    deinit {
        printLog("SwiftQRScanner 已釋放")
    }
    
    //MARK: 生命周期方法
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.presentationController?.delegate = self
        
        if !qrScannerConfiguration.hideNavigationBar {
            configureNavigationBar()
        } else {
            addCloseButton()
        }
        
        // 當前僅支持「豎屏」模式
        setDeviceOrientation()
        _delayCount = 0
        prepareQRScannerView()
        startScanningQRCode()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addButtons()
    }
    
    // 設置導航欄
    private func configureNavigationBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0,
                                                          y: 0,
                                                          width: view.frame.size.width,
                                                          height: 44))
        navigationBar.shadowImage = UIImage()
        view.addSubview(navigationBar)
        
        // 創建帶有標題和取消按鈕的導航項目
        let title = UINavigationItem(title: qrScannerConfiguration.title)
        let cancelBarButton = UIBarButtonItem(title: qrScannerConfiguration.cancelButtonTitle,
                                              style: .plain,
                                              target: self,
                                              action: #selector(dismissViewController))
        if let tintColor = qrScannerConfiguration.cancelButtonTintColor {
            cancelBarButton.tintColor = tintColor
        }
        title.leftBarButtonItem = cancelBarButton
        navigationBar.setItems([title], animated: false)
    }
    
    // 添加關閉按鈕
    private func addCloseButton() {
        let closeButton = CloseButton(frame: CGRect(x: 16, y: 16, width: 20, height: 20))
        closeButton.addTarget(self,
                              action: #selector(dismissViewController),
                              for: .touchUpInside)
        view.addSubview(closeButton)
    }
    
    // 設置設備方向為豎屏
    private func setDeviceOrientation() {
        if #available(iOS 16.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        } else {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue,
                                      forKey: "orientation")
        }
    }
    
    /**
     此方法調用其他方法，準備掃描 QR 代碼的視圖。
     - Parameter view: 將要添加掃描器的 UIView。
     */
    private func prepareQRScannerView() {
        setupCaptureSession(devicePosition) // 默認設備捕獲位置為後置
        addViedoPreviewLayer()
        addRoundCornerFrame()
    }
    
    // 創建一個帶有綠色邊框的角落矩形框（默認顏色）
    private func addRoundCornerFrame() {
        let width: CGFloat = self.view.frame.size.width / 1.5
        let height: CGFloat = self.view.frame.size.height / 2
        let roundViewFrame = CGRect(origin: CGPoint(x: self.view.frame.midX - width/2,
                                                    y: self.view.frame.midY - height/2),
                                    size: CGSize(width: width, height: width))
        self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        let qrFramedView = QRScannerFrame(frame: roundViewFrame)
        qrFramedView.thickness = qrScannerConfiguration.thickness
        qrFramedView.length = qrScannerConfiguration.length
        qrFramedView.radius = qrScannerConfiguration.radius
        qrFramedView.color = qrScannerConfiguration.color
        qrFramedView.autoresizingMask = UIView.AutoresizingMask(rawValue: UInt(0.0))
        self.view.addSubview(qrFramedView)
        if qrScannerConfiguration.readQRFromPhotos {
            addPhotoPickerButton(frame: CGRect(origin: CGPoint(x: self.view.frame.midX - width/2,
                                                               y: roundViewFrame.origin.y + width + 30),
                                               size: CGSize(width: self.view.frame.size.width/2.2, height: 36)))
        }
    }
    
    /**
     向視圖中添加一個按鈕，允許用戶從相冊選擇照片以掃描 QR 代碼。
     */
    
    private func addPhotoPickerButton(frame: CGRect) {
        let photoPickerButton = UIButton(frame: frame)
        let buttonAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let attributedTitle = NSMutableAttributedString(string: qrScannerConfiguration.uploadFromPhotosTitle,
                                                        attributes: buttonAttributes)
        photoPickerButton.setAttributedTitle(attributedTitle, for: .normal)
        photoPickerButton.center.x = self.view.center.x
        photoPickerButton.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        photoPickerButton.layer.cornerRadius = 18
        if let galleryImage = qrScannerConfiguration.galleryImage {
            photoPickerButton.setImage(galleryImage, for: .normal)
            photoPickerButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            photoPickerButton.titleEdgeInsets.left = 10
        }
        photoPickerButton.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        self.view.addSubview(photoPickerButton)
    }
    
    /**
     顯示適合的圖片選擇器（PHPhotoPicker 或 PhotoPicker），根據 iOS 版本允許用戶從相簿中選擇照片。
     */
    @objc private func showImagePicker() {
        if #available(iOS 14, *) {
            if let picker = photoPicker as? PHPhotoPicker {
                picker.present()
            }
        } else {
            if let picker = photoPicker as? PhotoPicker {
                picker.present(from: self.view)
            }
        }
    }
    
    // MARK: - QR 掃描器額外功能
    
    /**
     向視圖添加一個手電筒按鈕和一個相機切換按鈕。
     
     - 必需：`qrScannerConfiguration` 屬性必須擁有按鈕的有效圖片。
     */
    private func addButtons() {
        // 手電筒按鈕
        if let flashOffImage = qrScannerConfiguration.flashOnImage {
            let flashButton = RoundButton(frame: CGRect(x: 32,
                                                        y: view.frame.height - 100,
                                                        width: roundButtonWidth,
                                                        height: roundButtonHeight))
            flashButton.addTarget(self, action: #selector(toggleTorch), for: .touchUpInside)
            flashButton.setImage(flashOffImage, for: .normal)
            view.addSubview(flashButton)
            self.flashButton = flashButton
        }
        
        // 相機切換按鈕
        if let cameraImage = qrScannerConfiguration.cameraImage {
            let cameraSwitchButton = RoundButton(frame: CGRect(x: view.bounds.width - (roundButtonWidth + 32),
                                                               y: view.frame.height - 100,
                                                               width: roundButtonWidth,
                                                               height: roundButtonHeight))
            cameraSwitchButton.setImage(cameraImage, for: .normal)
            cameraSwitchButton.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
            view.addSubview(cameraSwitchButton)
        }
    }
    
    /**
     切換相機的手電筒。
     
     - 注意：如果設備使用前置相機，此函數無效。
     */
    @objc private func toggleTorch() {
        guard let currentInput = getCurrentInput() else { return }
        if currentInput.device.position == .front { return } // 前置相機：不需要手電筒
        
        guard let defaultDevice = defaultDevice else { return }
        if defaultDevice.isTorchAvailable {
            do {
                try defaultDevice.lockForConfiguration()
                defaultDevice.torchMode = defaultDevice.torchMode == .on ? .off : .on
                flashButton?.backgroundColor = defaultDevice.torchMode == .on ?
                UIColor.white.withAlphaComponent(0.3) : UIColor.black.withAlphaComponent(0.5)
                defaultDevice.unlockForConfiguration()
            } catch let error as NSError {
                printLog("手電筒錯誤：\(error)")
            }
        }
    }
    
    
    
    /**
     切換前置和後置相機。
     */
    @objc private func switchCamera() {
        if let frontDeviceInput = frontCaptureInput {
            captureSession.beginConfiguration()
            if let currentInput = getCurrentInput() {
                captureSession.removeInput(currentInput)
                let newDeviceInput = (currentInput.device.position == .front) ? defaultCaptureInput : frontDeviceInput
                captureSession.addInput(newDeviceInput!)
            }
            captureSession.commitConfiguration()
        }
    }
    
    /// 從捕捉會話中獲取當前相機輸入。
    private func getCurrentInput() -> AVCaptureDeviceInput? {
        if let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput {
            return currentInput
        }
        return nil
    }
    
    // MARK: - 關閉
    
    @objc private func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
        delegate?.qrScannerDidCancel(self)
    }
    
    // MARK: - 捕捉會話設置和管理
    
    /**
     開始運行捕捉會話以開始掃描 QR 代碼。
     
     - 注意：如果捕捉會話已經在運行，則此函數無效。
     */
    private func startScanningQRCode() {
        if captureSession.isRunning { return }
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    /**
     設置捕捉會話，指定相機位置（前置或後置）。
     
     - 参数 devicePostion: 要使用的相機位置（.front 或 .back）。
     
     - 注意：如果捕捉會話已經在運行，則此函數無效。
     */
    private func setupCaptureSession(_ devicePosition: AVCaptureDevice.Position) {
        if captureSession.isRunning { return }
        
        switch devicePosition {
        case .front:
            if let frontDeviceInput = frontCaptureInput {
                if !captureSession.canAddInput(frontDeviceInput) {
                    delegate?.qrScanner(self, didFailWithError: .inputFailed)
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                captureSession.addInput(frontDeviceInput)
            }
        case .back, .unspecified:
            if let defaultDeviceInput = defaultCaptureInput {
                if !captureSession.canAddInput(defaultDeviceInput) {
                    delegate?.qrScanner(self, didFailWithError: .inputFailed)
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                captureSession.addInput(defaultDeviceInput)
            }
        default:
            printLog("對於不支持的相機位置，什麼也不做")
        }
        
        if !captureSession.canAddOutput(dataOutput) {
            delegate?.qrScanner(self, didFailWithError: .outputFailed)
            self.dismiss(animated: true, completion: nil)
            return
        }
        captureSession.addOutput(dataOutput)
        dataOutput.metadataObjectTypes = dataOutput.availableMetadataObjectTypes
        dataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    }
    
    /**
     向視圖添加視頻預覽層，並可選地添加遮罩以限制掃描區域。
     */
    private func addViedoPreviewLayer() {
        videoPreviewLayer.frame = view.bounds
        view.layer.insertSublayer(videoPreviewLayer, at: 0)
        addMaskToVideoPreviewLayer()
    }
    
}

extension QRCodeScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    /**
     當在相機視圖中檢測到 QR 代碼時，調用此代理方法。
     
     - 参数 output: 接收到元數據對象的 AVCaptureMetadataOutput 實例。
     - 参数 metadataObjects: 一個包含檢測到的對象的 AVMetadataObject 實例的數組。
     - 参数 connection: 接收到元數據對象的 AVCaptureConnection。
     
     此函數迭代檢測到的對象，檢查 QR 代碼類型，驗證其在視圖中的位置，並觸發延遲，以便在通知代理掃描結果之前進行處理。
     */
    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from connection: AVCaptureConnection) {
        for data in metadataObjects {
            guard let transformed = videoPreviewLayer.transformedMetadataObject(for: data) as? AVMetadataMachineReadableCodeObject else { continue }
            if view.bounds.contains(transformed.bounds) {
                _delayCount += 1
                if _delayCount > delayCount {
                    if let unwrappedStringValue = transformed.stringValue {
                        delegate?.qrScanner(self, didScanQRCodeWithResult: unwrappedStringValue)
                    } else {
                        delegate?.qrScanner(self, didFailWithError: .emptyResult)
                    }
                    captureSession.stopRunning()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

extension QRCodeScannerController: UIAdaptivePresentationControllerDelegate {
    /// 通知代理表示呈現控制器已被關閉。
    ///
    /// - 参数 presentationController: 被關閉的呈現控制器。
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.delegate?.qrScannerDidCancel(self)
    }
}

extension QRCodeScannerController: ImagePickerDelegate {
    /// 當從圖片選擇器中選擇圖片時調用。
    ///
    /// - 参数 image: 選擇的圖片。
    public func didSelect(image: UIImage?) {
        if let selectedImage = image, let qrCodeData = selectedImage.parseQRCode() {
            if qrCodeData.isEmpty {
                showInvalidQRCodeAlert()
                return
            }
            self.delegate?.qrScanner(self, didScanQRCodeWithResult: qrCodeData)
            self.dismiss(animated: true)
        } else {
            showInvalidQRCodeAlert()
        }
    }
    
    /// 顯示無效 QR 代碼的警告。
    private func showInvalidQRCodeAlert() {
        let alert = UIAlertController(title: qrScannerConfiguration.invalidQRCodeAlertTitle,
                                      message: "",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: qrScannerConfiguration.invalidQRCodeAlertActionTitle,
                                      style: .cancel))
        self.present(alert, animated: true)
    }
}



// MARK: - 顯示方向處理

extension QRCodeScannerController {
    /// 確保方向始終為直立模式。
    override public var shouldAutorotate: Bool {
        return false
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

// MARK: - 遮罩和提示文字

extension QRCodeScannerController {
    /// 向視頻預覽層添加遮罩層。
    private func addMaskToVideoPreviewLayer() {
        let qrFrameWidth: CGFloat = self.view.frame.size.width / 1.5
        let scanFrameWidth: CGFloat = self.view.frame.size.width / 1.8
        let scanFrameHeight: CGFloat = self.view.frame.size.width / 1.8
        let screenHeight: CGFloat = self.view.frame.size.height / 2
        let roundViewFrame = CGRect(origin: CGPoint(x: self.view.frame.midX - scanFrameWidth/2,
                                                    y: self.view.frame.midY - screenHeight/2 + (qrFrameWidth-scanFrameWidth)/2),
                                    size: CGSize(width: scanFrameWidth, height: scanFrameHeight))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.fillColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        let path = UIBezierPath(roundedRect: roundViewFrame, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 10, height: 10))
        path.append(UIBezierPath(rect: view.bounds))
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        view.layer.insertSublayer(maskLayer, above: videoPreviewLayer)
        addHintTextLayer(maskLayer: maskLayer)
    }
    
    /// 在遮罩層上方添加提示文字層。
    ///
    /// - Parameters:
    ///   - maskLayer: 要添加提示文字層的遮罩層。
    private func addHintTextLayer(maskLayer: CAShapeLayer) {
        guard let hint = qrScannerConfiguration.hint else { return }
        let hintTextLayer = CATextLayer()
        hintTextLayer.fontSize = 18.0
        hintTextLayer.string = hint
        hintTextLayer.alignmentMode = .center
        hintTextLayer.contentsScale = UIScreen.main.scale
        hintTextLayer.frame = CGRect(x: spaceFactor,
                                     y: self.view.frame.midY - self.view.frame.size.height/4 - 62,
                                     width: view.frame.size.width - (2.0 * spaceFactor),
                                     height: 22)
        hintTextLayer.foregroundColor = UIColor.white.withAlphaComponent(0.7).cgColor
        view.layer.insertSublayer(hintTextLayer, above: maskLayer)
    }
}

// MARK: - 日誌調試
extension QRCodeScannerController {
    func printLog(_ message: String,
                  file: String = #file,
                  function: String = #function,
                  line: Int = #line) {
#if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName)::\(function)::\(line)] \(message)")
#endif
    }
}

#endif
