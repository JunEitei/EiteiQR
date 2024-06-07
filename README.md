# EiteiQR

EiteiQR 是一個輕量級的 iOS 二維碼生成與掃描庫，旨在為開發者提供一個簡單易用的接口，來集成二維碼生成與掃描功能。它支持多種二維碼格式，並且具有高效的掃描性能，適用於各種 iOS 應用開發場景。

## 功能特點

- **簡單易用**：提供直觀的 API，簡化二維碼的生成和掃描流程。
- **多格式支持**：支持多種二維碼格式，包括常見的 QR Code。
- **高效掃描**：集成高效的掃描引擎，支持快速掃描和解析。
- **自定義選項**：支持自定義二維碼生成參數，滿足各種場景需求。

## 安裝

### 將以下代碼添加到您的 `Podfile` 中：

```ruby
pod 'EiteiQR'


### 使用

import UIKit
import EiteiQR

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 二維碼生成示例
        let qrCodeImage = EiteiQR.generateQRCode(from: "https://example.com", size: CGSize(width: 200, height: 200))
        let imageView = UIImageView(image: qrCodeImage)
        imageView.center = view.center
        view.addSubview(imageView)
        
        // 二維碼掃描示例
        let scannerButton = UIButton(type: .system)
        scannerButton.setTitle("掃描二維碼", for: .normal)
        scannerButton.addTarget(self, action: #selector(scanQRCode), for: .touchUpInside)
        scannerButton.frame = CGRect(x: 100, y: 400, width: 200, height: 50)
        view.addSubview(scannerButton)
    }
    
    @objc func scanQRCode() {
        let scanner = EiteiQRScannerViewController()
        scanner.didFindCode = { code in
            print("掃描結果：\(code)")
        }
        present(scanner, animated: true, completion: nil)
    }
}
