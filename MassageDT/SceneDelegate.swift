//
//  SceneDelegate.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/16.
//

import UIKit
import Combine
import StoreKit
import CoreTelephony

class RootViewToggle {
    static let `default` = RootViewToggle()
    @Published var switchRootView: Int = 0
    @Published var updateElegance: Int = 0
    func replaceRootView() {
        self.switchRootView = Int(arc4random_uniform(100))
    }
    
    func updateEleganceData() {
        self.updateElegance = Int(arc4random_uniform(100))
    }
}


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var disposeBag = Set<AnyCancellable>()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        RootViewToggle.default.$switchRootView
            .dropFirst()
            .sink {[weak self] _ in
                self?.switchRootView()
            }
            .store(in: &disposeBag)
        
        if SystemCaching.isFirstInstall {
            window?.rootViewController = BaseNavigationController(rootViewController: FirstInstallVC())
            window?.makeKeyAndVisible()
        } else {
            switchRootView()
        }
        
    }
    
    func switchRootView() {
        if !SystemCaching.isLogin {
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
            NetWork.retrievePermissionInfo { model in
                SystemCaching.kefu = model?.kefu ?? ""
                if model?.prelogin == "1" {
                    DispatchQueue.main.async {
                        self.window?.rootViewController = LoginVC()
                        self.window?.makeKeyAndVisible()
                    }
                } else {
                    DispatchQueue.main.async {
                        BaseTabBarControllerView.tab = BaseTabBarControllerView()
                        BaseTabBarControllerView.tab.tabBar.isHidden = false
                        self.window?.rootViewController = BaseTabBarControllerView.tab
                        self.window?.makeKeyAndVisible()
                    }
                   
                }
            }
        } else {
            BaseTabBarControllerView.tab = BaseTabBarControllerView()
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
            NetWork.retrievePermissionInfo { model in
                SystemCaching.kefu = model?.kefu ?? ""
                SystemCaching.find_url = model?.find_url ?? ""
                BaseTabBarControllerView.tab.tabBar.isHidden = false
                if model?.tab == 1 {
                    BaseTabBarControllerView.tab.selectedIndex = 1
                }
                let rank = model?.rank == 1
                DispatchQueue.main.async {
                    self.window?.rootViewController = BaseTabBarControllerView.tab
                    self.window?.makeKeyAndVisible()
                }
                if rank {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if let windowScene = self.window?.windowScene {
                            SKStoreReviewController.requestReview(in: windowScene)
                        }
                    }
                }
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

