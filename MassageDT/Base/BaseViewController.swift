//
//  BaseViewController.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/18.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.edgesForExtendedLayout = .all
        initializeUIInfo()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(navigationBarHiden(), animated: animated)
    }
    
    func initializeUIInfo() {
        self.view.backgroundColor = UIColor("#FAFAFA")
    }
    
    func navigationBarHiden() -> Bool {
        return false
    }
}
 
extension BaseViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.navigationController?.navigationBar.isHidden = navigationBarHiden()
    }
}
