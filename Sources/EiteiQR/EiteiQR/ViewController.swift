import UIKit

public class ViewController: UITabBarController, UITabBarControllerDelegate {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設置視圖控制器和 TabBar 項目
        setupViewControllers()
        
        // 配置 TabBar 的樣式
        configureTabBar()
        
        // 調整 TabBarItem 的圖片位置和大小
        adjustTabBarItems()
        
        // 設置代理
        self.delegate = self
    }
    
    private func setupViewControllers() {
        // 初始化歷史視圖控制器和創建視圖控制器
        let historyViewController = QRHistoryViewController()
        historyViewController.tabBarItem = UITabBarItem(title: "History", image: Eitei.shared.loadImage(named: "icon_history")?.withRenderingMode(.alwaysOriginal), tag: 1)
        
        let creatorViewController = QRCreatorViewController()
        creatorViewController.tabBarItem = UITabBarItem(title: "Create", image: Eitei.shared.loadImage(named: "icon_create")?.withRenderingMode(.alwaysOriginal), tag: 0)
        
        // 設置視圖控制器集合
        self.viewControllers = [historyViewController, creatorViewController]
        
        // 在這里統一設置代理
        creatorViewController.delegate = historyViewController
        
    }
    
    private func configureTabBar() {
        // 設置 TabBar 的基本樣式
        tabBar.tintColor = .white
        tabBar.barTintColor = .clear
        tabBar.backgroundColor = .clear
    }
    
    private func adjustTabBarItems() {
        guard let items = tabBar.items else { return }
        
        for item in items {
            // 圖標文字位置微調
            item.imageInsets = UIEdgeInsets(top: -22, left: 0, bottom: -5, right: 0) // 調整圖標位置，使其向上移動
            
            // 純手工放大圖標
            if let originalImage = item.image {
                let newSize = CGSize(width: 33, height: 33) // 設定新的圖標大小
                UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
                originalImage.draw(in: CGRect(origin: .zero, size: newSize))
                item.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
            
            // 調整文字大小
            item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
            item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .selected)
        }
    }
}
