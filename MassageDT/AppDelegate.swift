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
import Network

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        self.talkingDataSDK()
        DispatchQueue.main.async {
            self.initKeyboardManager()
            self.initProgressHUD()
            self.initializationOneClickLogin()
        }
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
    
    
    
    
    
    func initKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    func initProgressHUD() {
        ProgressHUD.animationType = .circleArcDotSpin
        ProgressHUD.fontStatus = .systemFont(ofSize: 14)
    }
    
    func talkingDataSDK() {
        TalkingDataSDK.initSDK("4A62E26FFBD2441591FDE9FA39A18140", channelId: "AppStore", custom: "")
        TalkingDataSDK.startA()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //        return WXApi.handleOpen(url, delegate: self)
        if url.host == "safepay" {
            // 支付宝支付
            return AlipayTool.instance.openURL(url: url)
        } else if url.host == "pay" {
            // 微信支付
            return WxPayTool.instance.openURL(url: url)
        }
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool {
        return WxPayTool
            .instance.openUniversalLink(userActivity: userActivity)
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

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlType = "dtlvision.app.com://"
        if let urlStr = url.absoluteString.removingPercentEncoding, urlStr.contains(urlType) {
            let index = urlType.count-1
            let startIndex = urlStr.index(urlStr.startIndex, offsetBy: urlType.count)
            let json = urlStr.suffix(from: startIndex)
            if let data = json.data(using: .utf8) {
                do {
                    // 将 Data 类型的 JSON 数据转换为字典
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let topVC = topViewController() {
                            JSInteraction.jumpToVC(topVC, body: jsonObject)
                        }
                    }
                } catch {
                    print("JSON 解析错误: \(error)")
                }
            }
        }
        
        return true
    }
}

//let shanYanAppID: String = "0Sjtfn03"

let shanYanAppID: String = "uMFVetnz"
