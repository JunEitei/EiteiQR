# EiteiQR V2

![CocoaPods](https://img.shields.io/cocoapods/v/EiteiQR.svg)

EiteiQR 是一個輕量級的 iOS 二維碼生成與掃描庫，旨在為開發者提供一個簡單易用的接口，來集成二維碼生成與掃描功能。它支持多種二維碼格式，並且具有高效的掃描性能，適用於各種 iOS 應用開發場景。

## 功能特點

- **簡單易用**：提供直觀的 API，簡化二維碼的生成和掃描流程。
- **多格式支持**：支持多種二維碼格式，包括常見的 QR Code。
- **高效掃描**：集成高效的掃描引擎，支持快速掃描和解析。
- **自定義選項**：支持自定義二維碼生成參數，滿足各種場景需求。

## 安裝

### 將以下代碼添加到您的 `Podfile` 中：

```ruby
pod 'EiteiQR', :git => 'https://github.com/JunEitei/EiteiQR'

```

## 使用

1. **導入庫**：
   ```swift
   import EiteiQR
   ```

2. **設置根視圖控制器**：
   ```swift
   window?.rootViewController = ViewController()
   ```

EiteiQR 的安裝與使用極其簡單，只需2行代碼即可集成強大的二維碼生成與掃描功能。讓您的應用更加智能和高效！

### 參考EiteiQRScanner
