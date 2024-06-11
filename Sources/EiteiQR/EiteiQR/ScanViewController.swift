//
//  ScanViewController.swift
//  EiteiQRScanner
//
//  Created by damao on 2024/6/6.
//

#if canImport(UIKit)
import UIKit

class ScanViewController: UIViewController {
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        // 畫面出現時，加載掃碼界面
        scanQRCodeWithExtraOptions(self)

    }
    
    // 當點擊「掃描 QR 碼」按鈕時調用此方法
    @IBAction func scanQRCodeWithExtraOptions(_ sender: Any) {
        
        // 設置 QR 碼掃描器的配置對象
        var configuration = QRScannerConfiguration()
        
        // 設置相機按鈕的圖示
        configuration.cameraImage = UIImage(named: "camera")
        
        // 設置閃光燈開啟按鈕的圖示
        configuration.flashOnImage = UIImage(named: "flash-on")
        
        // 設置相冊按鈕的圖示
        configuration.galleryImage = UIImage(named: "photos")
        
        // 設置掃描界面的標題
        configuration.title = "掃描二維碼"
        
        // 設置掃描提示文字
        configuration.hint = "請對準二維碼，進行掃描"
        
        // 設置從相冊選取二維碼的按鈕標題
        configuration.uploadFromPhotosTitle = "從相簿選取"
        
        // 設置無效二維碼的提示框標題
        configuration.invalidQRCodeAlertTitle = "無效的二維碼"
        
        // 設置無效二維碼提示框的確定按鈕標題
        configuration.invalidQRCodeAlertActionTitle = "確定"
        
        // 設置取消按鈕標題
        configuration.cancelButtonTitle = "取消"
        
        let scanner = QRCodeScannerController(qrScannerConfiguration: configuration) // 創建掃描器視圖控制器
        scanner.delegate = self // 設置委託對象，實現掃描結果的回調
        self.present(scanner, animated: true, completion: nil) // 顯示掃描器視圖控制器
        
    }
}

// MARK: - QRScannerCodeDelegate 協議的擴展，用於處理掃描結果和錯誤
extension ScanViewController: QRScannerCodeDelegate {
    
    
    // 切換到第一個 Tab
    private func switchToFirstTab() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
        }
    }
    
    // 當成功掃描到 QR 碼時調用此方法
    func qrScanner(_ controller: UIViewController, didScanQRCodeWithResult result: String) {
        guard let generateVC = tabBarController?.viewControllers?[0] as? GenerateViewController else {
            print("無法獲取 GenerateViewController")
            return
        }
        generateVC.inputTextField.text = result  // 將掃描結果放入 inputTextField
        generateVC.generateQRCode(withText: result)  // 重新生成二維碼
        
        // 更新歷史紀錄數據
        generateVC.historyRecords.append(result)
        generateVC.tableView.reloadData()  // 刷新表格視圖
        
        
        // 切換回第一個 Tab
        switchToFirstTab()
    }
    
    // 當掃描過程中發生錯誤時調用此方法
    func qrScanner(_ controller: UIViewController, didFailWithError error: EiteiQR.QRCodeError) {
        print("掃描錯誤：\(error.localizedDescription)")
        
        // 切換回第一個 Tab
        switchToFirstTab()
    }
    
    // 當用戶取消掃描操作時調用此方法
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("QR 掃描器已取消")
        
        // 切換回第一個 Tab
        switchToFirstTab()
    }
    
}

#endif
