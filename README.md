# EiteiQR

![CocoaPods](https://img.shields.io/cocoapods/v/EiteiQR.svg)


## 使用方法（Cocoapods）

1. **新建一個Swift項目，類型選擇Storyboard；**

2. **把Main.storyboard和ViewController.swift刪掉，同時在Info.plist中把Storyboard Name = Main這一行刪除（在最末尾）；**

3. **右鍵單擊Info.plist，選擇Open as source code，並在最後一個Dict結束標籤之前添加如下代碼：**
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
4. **在項目跟目錄放置Podfile，並添加如下內容（“Example-Cocoapods”替換為你的項目名稱）：**
```ruby

platform :ios, '12.0'

use_frameworks!

target 'Example-Cocoapods' do
  
  pod 'EiteiQR',  :git => 'https://github.com/JunEitei/EiteiQR'

end
```
5. **在根目錄運行pod install，完成後打開Example-Cocoapods.xcworkspace（“Example-Cocoapods”替換為你的項目名稱）；**

6. **SceneDelegate.swift替換為如下代碼：**
```ruby
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
7. （Optional）**有時在Build Settings裡需要將User Script Sandboxing設置為No。**

8. （Optional）**需要時可以執行下面的命令以清理緩存：**：
```ruby
pod cache clean --all
pod deintegrate
pod clean
rm -rf ~/Library/Developer/Xcode/DerivedData/*
pod install --repo-update
```
9. （Optional）**可適當增加你自己的應用程式圖標和其他信息。**
    
10. **運行項目即可！**


## 使用方法（SPM）

1. **新建一個Swift項目，類型選擇Storyboard；**

2. **把Main.storyboard和ViewController.swift刪掉，同時在Info.plist中把Storyboard Name = Main這一行刪除（在最末尾）；**

3. **右鍵單擊Info.plist，選擇Open as source code，並在最後一個Dict結束標籤之前添加如下代碼：**
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

4. **SceneDelegate.swift替換為如下代碼：**
```ruby
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
5. **點擊項目的Build Target，在Build Phases一欄找到Link Binary With Libraryies,點擊加號，最下面選擇Add Other然後Add Package Dependency，在彈出的對話框中，搜索eiteiqr，看到以後點擊Add Package，再點擊一次，即可導入成功。**
   
6. （Optional）**可適當增加你自己的應用程式圖標和其他信息。**

7. **在根目錄添加Package.swift，並添加如下代碼（Example-SPM換成你自己的項目名稱）：**
```ruby
// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Example-SPM",
    defaultLocalization: "en", 

    platforms: [
        .iOS(.v14),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "Example-SPM",
            targets: ["Example-SPM"]),
    ],
    dependencies: [
        .package(path: "../"),
    ],
    targets: [
        .target(
            name: "Example-SPM",
            dependencies: ["EiteiQR"], path: "Example-SPM")
    ]
)

```
9. **運行項目即可！**
