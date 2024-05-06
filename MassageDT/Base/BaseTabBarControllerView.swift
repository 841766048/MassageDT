//
//  BaseTabBarControllerView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/19.
//

import UIKit

class BaseTabBarControllerView: UITabBarController, UITabBarControllerDelegate {
    static var tab = BaseTabBarControllerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        initializeUIInfo()
        // Do any additional setup after loading the view.
    }
    func initializeUIInfo() {
        let nav_eleganceVC = setUpVC(title: "风采", norImage: "fengcai", selImage: "fengcai_select", vc: EleganceVC())
        let feisureVC = LeisureVC()
        if SystemCaching.isLogin {
            feisureVC.loadURL()
        }
        let nav_leisureVC = setUpVC(title: "休闲", norImage: "xiuxian", selImage: "xiuxian_select", vc: feisureVC)
        nav_leisureVC.isLogin = true
        
        let message = MD_MessageVC()
        let nav_message = setUpVC(title: "消息", norImage: "message", selImage: "message_sel", vc: message)
        nav_leisureVC.isLogin = true
        
        let nav_mineVC = setUpVC(title: "我的", norImage: "my", selImage: "my_select", vc: MineVC())
        nav_mineVC.isLogin = true
        
        self.viewControllers = [nav_eleganceVC, nav_leisureVC, nav_message, nav_mineVC]
        self.tabBar.backgroundColor = UIColor("#FFFFFF")
        self.tabBar.barTintColor = UIColor("#FFFFFF")
        self.tabBar.tintColor = UIColor("#4E96EB")
        self.tabBar.unselectedItemTintColor = UIColor("#1E1E1E")
        
        let appearance = UITabBar.appearance()
        let tabBarAppearance = UITabBarAppearance()
        //设置tabar背景色
        tabBarAppearance.backgroundColor = UIColor("#FFFFFF")
        // 设置普通状态下的字体大小
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .semibold)]
        // 设置选中状态下的字体大小
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .semibold)]
        appearance.standardAppearance = tabBarAppearance
        appearance.scrollEdgeAppearance = tabBarAppearance
    }
    
    func setUpVC(title: String, norImage: String, selImage: String, vc: UIViewController) -> BaseNavigationController {
        let nav = BaseNavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.selectedImage = UIImage(named: selImage)
        nav.tabBarItem.image = UIImage(named: norImage)
        return nav
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("viewController == \(viewController)")
        if let nav = viewController as? BaseNavigationController {
            if nav.isLogin && !SystemCaching.isLogin {
                topViewController()?.navigationController?.pushViewController(LoginVC(), animated: true)
                return false
            }
        }
        return true
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("tabBarController == \(tabBarController.selectedIndex)")
    }
}
