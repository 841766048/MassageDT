//
//  BaseViewController.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/18.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    var disposeBag = Set<AnyCancellable>()
    lazy var backButton: UIButton = {
        let back = UIButton()
        back.frame.size = CGSize(width: 22, height: 22)
        back.setImage(UIImage(named: "back"), for: .normal)
        back.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return back
    }()
    
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AudioManager.shared.stopAudio()
    }
    func initializeUIInfo() {
        self.view.backgroundColor = UIColor("#FAFAFA")
    }
    
    func navigationBarHiden() -> Bool {
        return false
    }
    func setBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
    }
    @objc func backButtonClick() {}
    
    func getNickName() -> String {
        var nickNames = SystemCaching.nickName
        if nickNames.count > 0 {
            for str in nickNames {
                let to = "<0>"+SystemCaching.phone+"<0>"
                if str.contains(to) {
                    let resultString = str.replacingOccurrences(of: "<0>"+SystemCaching.phone+"<0>", with: "")
                    return resultString
                }
            }
            let nickName = "用户\(Int(arc4random_uniform(10000)))"
            nickNames.append(nickName)
            SystemCaching.nickName = nickNames
            return nickName
        } else {
            let nickName = "用户\(Int(arc4random_uniform(10000)))"
            nickNames.append(nickName)
            SystemCaching.nickName = nickNames
            return nickName
        }
    }
}
 
extension BaseViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.navigationController?.navigationBar.isHidden = navigationBarHiden()
    }
}
