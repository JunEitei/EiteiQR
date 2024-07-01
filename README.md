# EiteiQR

![CocoaPods](https://img.shields.io/cocoapods/v/EiteiQR.svg)


## 使用（Cocoapods）

1. **新建一個Swift項目，類型選擇Storyboard**

2. **把Main.storyboard和ViewController.swift刪掉，同時在Info.plist中把Storyboard Name = Main這一行刪除**


3. **右鍵單擊Info.plist，選擇Open as source code，並在Dict標籤結束之前添加如下代碼**
   ```xml
    <key>NSAppleMusicUsageDescription</key>
    <string>Used to scan QR code</string>
    <key>NSCameraUsageDescription</key>
    <string>Used to scan QR code</string>
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>Used to scan QR code</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Used to scan QR code</string>
   ```
4. **在項目跟目錄放置Podfile，並添加如下內容（“Example-Cocoapods”替換為你的項目名稱）**
   ```swift
platform :ios, '12.0'

use_frameworks!

target 'Example-Cocoapods' do
  
  pod 'EiteiQR',  :git => 'https://github.com/JunEitei/EiteiQR'

end
   ```
   
5. **在根目錄運行pod install，完成後打開Example-Cocoapods.xcworkspace（“Example-Cocoapods”替換為你的項目名稱）**

6. **SceneDelegate.swift替換為如下代碼**
   ```xml

import UIKit
import EiteiQR

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)

        window?.rootViewController = ViewController()

        window?.makeKeyAndVisible()
    }

}
   ```
7. （Optional）**有時在Build Settings裡需要將User Script Sandboxing設置為No**

8. （Optional）**需要時可以執行下面的命令以清理緩存**：
```ruby
pod cache clean --all
pod deintegrate
pod clean
rm -rf ~/Library/Developer/Xcode/DerivedData/*
pod install --repo-update
```

