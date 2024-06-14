# EiteiQR V3

![CocoaPods](https://img.shields.io/cocoapods/v/EiteiQR.svg)

## 安裝
```ruby
pod 'EiteiQR', :git => 'https://github.com/JunEitei/EiteiQR', :tag => '2.0.0'

```


## 更新
```ruby
pod cache clean EiteiQR
pod deintegrate
pod install --repo-update
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
   
## Info.plist設置項
```swift
    <key>NSAppleMusicUsageDescription</key>
    <string>Used to scan QR code</string>
    <key>NSCameraUsageDescription</key>
    <string>Used to scan QR code</string>
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>Used to scan QR code</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Used to scan QR code</string>
```
