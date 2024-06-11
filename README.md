# EiteiQR V2

![CocoaPods](https://img.shields.io/cocoapods/v/EiteiQR.svg)

EiteiQR是一個輕量級iOS二維碼框架。提供了掃碼、解析、生成、保存到相冊、歷史功能。

## 安裝

### 將以下代碼添加到您的 `Podfile` 中：

```ruby
pod 'EiteiQR', :git => 'https://github.com/JunEitei/EiteiQR'

```

## 使用只需2行代碼（可參考EiteiQRScanner）

1. **導入庫**：
   ```swift
   import EiteiQR
   ```

2. **設置根視圖控制器**：
   ```swift
   window?.rootViewController = ViewController()
   ```
