# EiteiQR V2

![CocoaPods](https://img.shields.io/cocoapods/v/EiteiQR.svg)

## 安裝
```ruby
pod 'EiteiQR', :git => 'https://github.com/JunEitei/EiteiQR', :tag => '2.0.0'

```

## 使用

1. **導入庫**：
   ```swift
   import EiteiQR
   ```

2. **設置根視圖控制器**：
   ```swift
   window?.rootViewController = EiteiQR.ViewController()
   ```

## 更新
```ruby
pod cache clean EiteiQR
pod deintegrate
pod install --repo-update
```

