# EiteiQR

![CocoaPods](https://img.shields.io/cocoapods/v/EiteiQR.svg)


## 使用方法（Cocoapods）

1. **新建一個Swift項目，類型選擇Storyboard；**

2. **執行以下三個操作**
<table>
    <tr>
        <td>①</td>
        <td>
            <pre><code>把Main.storyboard和ViewController.swift刪掉</code></pre>
        </td>
    </tr>
    <tr>
        <td>②</td>
        <td>
            <pre><code>同時在Info.plist中（最末尾）把Storyboard Name = Main這一行刪除</code></pre>
        </td>
    </tr>
    <tr>
        <td>③</td>
        <td>
            <pre><code>點擊TARGETS，在Build Settings中把Main Storyboard File Base Name置為空</code></pre>
        </td>
    </tr>
</table>

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
4. **在項目跟目錄放置Podfile，並添加如下內容（“Example-Cocoapods”替換為你的項目名稱），然後在根目錄運行pod install**
```ruby

platform :ios, '12.0'

use_frameworks!

target 'Example-Cocoapods' do
  
  pod 'EiteiQR',  :git => 'https://github.com/JunEitei/EiteiQR'

end
```
5. **完成後打開‘你的項目名.xcworkspace’，並將SceneDelegate.swift替換為如下代碼：**
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
6. （Optional）**必要時在Build Settings裡將User Script Sandboxing設置為No。**

7. （Optional）**必要時執行下面的命令以清理Pod緩存：**：
```ruby
pod cache clean --all
pod deintegrate
pod clean
rm -rf ~/Library/Developer/Xcode/DerivedData/*
pod install --repo-update
```    
7.  **運行項目即可！**


## 使用方法（SPM）

1. **新建一個Swift項目，類型選擇Storyboard。接著在根目錄新建Package.swift，內容如下**
```swift
// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package()
```
2. **執行以下三個操作**
<table>
    <tr>
        <td>①</td>
        <td>
            <pre><code>把Main.storyboard和ViewController.swift刪掉</code></pre>
        </td>
    </tr>
    <tr>
        <td>②</td>
        <td>
            <pre><code>同時在Info.plist中（最末尾）把Storyboard Name = Main這一行刪除</code></pre>
        </td>
    </tr>
    <tr>
        <td>③</td>
        <td>
            <pre><code>在Build Settings中把UIKit Main Storyboard File Base Name置為空</code></pre>
        </td>
    </tr>
</table>

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
5. **按順序執行以下三步**
<table>
    <tr>
        <td>①</td>
        <td>
            <pre><code>點擊項目的Build Target，在Build Phases找到“Link Binary With Libraryies”,點擊加號</code></pre>
        </td>
    </tr>
    <tr>
        <td>②</td>
        <td>
            <pre><code>彈出的對話框中點擊Add Other，然後Add Package Dependency</code></pre>
        </td>
    </tr>
    <tr>
        <td>③</td>
        <td>
            <pre><code>在彈出的對話框中，點擊Add Local（亦可搜索eiteiqr拉取遠程的）</code></pre>
        </td>
    </tr>
</table>

6. **運行項目即可**