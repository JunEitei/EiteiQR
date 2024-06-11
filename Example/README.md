# 二維碼掃碼與生成器

 - EiteiQRScanner是一個簡單的 iOS 應用，實現了二維碼的生成和顯示功能，並能夠將生成的二維碼保存到相冊，還具備掃碼功能，支持用戶掃描二維碼並顯示掃描結果。應用界面簡潔，支持文本輸入，並且能夠顯示歷史紀錄。其基於EiteiQR (https://github.com/JunEitei/EiteiQR) 開發。

# EiteiQR  ![CocoaPods](https://img.shields.io/cocoapods/v/EiteiQR.svg)
EiteiQR是一個輕量級的 iOS 二維碼生成與掃描庫，旨在為開發者提供一個簡單易用的接口，來集成二維碼生成與掃描功能。它支持多種二維碼格式，並且具有高效的掃描性能，適用於各種 iOS 應用開發場景。


## 功能特點

- **二維碼生成**：用戶可以輸入文本，生成相應的二維碼。
- **保存圖片**：長按二維碼圖片，可將其保存到相冊。
- **掃碼功能**：支持使用手機相機掃描二維碼，掃描成功後顯示掃描結果，並動態刷新二維碼。
- **歷史紀錄**：顯示用戶生成過的二維碼文本歷史記錄。

## 技術細節

### 編程語言與框架

- **開發語言**：Swift
- **框架**：UIKit, SnapKit
- **第三方庫**：
  - [QRCode](https://github.com/kevin0317/QRCode)：用於二維碼的生成。

### 硬件與許可權

- **相機許可權**：應用需要訪問用戶的相機來掃描二維碼，請確保在 `Info.plist` 中正確設置相機使用權限。

## 附加信息

- **開源許可證**：MIT License
- **聯繫方式**：若有任何疑問或建議，歡迎通過郵箱與我們聯繫：`jun.huang@eitei.co.jp`。

## 安裝與使用

1. **下載與安裝**：可以通過 GitHub 或 App Store 下載應用。
2. **使用指南**：
   - 在生成二維碼頁面，輸入文本並點擊生成按鈕。
   - 長按生成的二維碼圖片，選擇保存到相冊。
   - 在掃碼頁面，授予相機訪問權限後，對準二維碼掃描即可顯示結果。
   - 查看歷史紀錄頁面，瀏覽過去生成的二維碼文本。

這個應用旨在提供一個簡單易用的二維碼生成與掃描體驗，希望能對用戶帶來便捷的功能和流暢的使用體驗。

## 通過Swift Package Manager安裝

將以下依賴項添加到您的 `Package.swift` 文件中：

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "EiteiQRScanner",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "EiteiQRScanner",
            targets: ["EiteiQRScanner"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JunEitei/EiteiQR.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "EiteiQRScanner",
            dependencies: ["EiteiQR"]),
        .testTarget(
            name: "EiteiQRScannerTests",
            dependencies: ["EiteiQRScanner"]),
    ],
    swiftLanguageVersions: [.v5]
)
