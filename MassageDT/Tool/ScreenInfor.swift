//
//  ScreenInfor.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/17.
//

import UIKit

/// 获取屏幕宽度
var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

/// 获取屏幕高度
var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}
/// 获取状态栏的高度
var statusBarHeight: CGFloat {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        return windowScene.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        return 0
    }
}

/// 获取导航栏的高度
var navigationBarHeight: CGFloat {
    return 44
}

/// 获取导航栏总高度
var totalNavBarHeight: CGFloat {
    return 44 + statusBarHeight
}
/// 底部安全边距
var bottomSafeMargin: CGFloat {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        if let statusBarManager = windowScene.statusBarManager {
            let statusBarFrame = statusBarManager.statusBarFrame
            let statusBarHeight = statusBarFrame.height
            let safeAreaBottom = statusBarHeight > 20 ? 34 : 0
            return CGFloat(safeAreaBottom)
        }
    }
    return 0
}

var keyWindow: UIWindow? {
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    let keyWindow = windowScene?.windows.first(where: { $0.isKeyWindow })
    return keyWindow
}

func topViewController(_  base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let  nav =  base as? UINavigationController {
        return topViewController(  nav.visibleViewController)
    }
    if let  tab =  base as? UITabBarController {
        if let  selected =  tab.selectedViewController {
            return  topViewController( selected)
        }
    }
    if let  presented =  base?.presentedViewController {
        return  topViewController( presented)
    }
    return  base
}
