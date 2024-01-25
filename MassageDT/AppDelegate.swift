//
//  AppDelegate.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/16.
//

import UIKit
import ProgressHUD
import CL_ShanYanSDK
import AdSupport
import AppTrackingTransparency
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 闪验初始化
        initializationOneClickLogin()
        initKeyboardManager()
        initProgressHUD()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    /// 初始化闪验一键登录
    func initializationOneClickLogin() {
        CLShanYanSDKManager.initWithAppId(shanYanAppID) { result in
            if result.error == nil {
                CLShanYanSDKManager.preGetPhonenumber { result in
                    if let number = result.data?["number"] as? String {
                        AppPeriod.oneClickLoginPreFetchedPhoneNumber = number
                    }
                }
            } else {
                debugPrint("error = \(String(describing: result.error))")
            }
        }
    }
    
    func initIDFA() {
        ATTrackingManager.requestTrackingAuthorization { status in
            if status == .authorized {
                let idfa = ASIdentifierManager().advertisingIdentifier.uuidString
                SystemCaching.idfa = idfa
            }
        }
    }
    
    func initPush() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func initKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    func initProgressHUD() {
        ProgressHUD.animationType = .circleArcDotSpin
        ProgressHUD.fontStatus = .systemFont(ofSize: 14)
    }
}

extension AppDelegate {
    /// 获取deviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let dtString = deviceToken.reduce("",{$0 + String(format:"%02x",$1)})
        SystemCaching.deviceToken = dtString
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("deviceToken失败: \(error.localizedDescription)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 处理前台推送
        completionHandler([.sound,.banner])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 处理用户响应推送
        let userInfo = response.notification.request.content.userInfo
        pushNotificationHandler(userInfo)
        completionHandler()
    }
    
    func pushNotificationHandler(_ parameters: [AnyHashable : Any]) {
        
    }
}

let shanYanAppID: String = "0Sjtfn03"
