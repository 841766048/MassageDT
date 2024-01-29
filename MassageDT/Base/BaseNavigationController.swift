//
//  BaseNavigationController.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/18.
//

import UIKit

class BaseNavigationController: UINavigationController {
    var isLogin = false
    lazy var backButton: UIButton = {
        let back = UIButton()
        back.frame.size = CGSize(width: 22, height: 22)
        back.setImage(UIImage(named: "back"), for: .normal)
        back.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return back
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
    }
    
    func initNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor("#1E1E1E")
        ]
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = nil
        appearance.backgroundEffect = nil
        appearance.backgroundColor = UIColor.clear
        let rect = UIApplication.shared.statusBarFrame
        let status = UIView(frame: CGRect(x: 0, y: -rect.height, width: rect.width, height: rect.height))
        status.backgroundColor = UIColor.white
        self.navigationBar.addSubview(status)
        self.navigationBar.backgroundColor = UIColor.white
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
            viewController.hidesBottomBarWhenPushed = true
        } else {
            viewController.hidesBottomBarWhenPushed = false
        }
        UIView.setAnimationsEnabled(true)
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func backButtonClick() {
        self.popViewController(animated: true)
    }
}
