//
//  WxPayTool.swift
//  MassageDT
//
//  Created by wealon on 2024.
//  MassageDT.
//


import Foundation
import ProgressHUD


class WxPayTool: NSObject, WXApiDelegate {
    static let instance = WxPayTool()
    
    func openURL(url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: WxPayTool.instance)
    }
    
    func openUniversalLink(userActivity: NSUserActivity) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: WxPayTool.instance)
    }
    
    /// 微信支付
    func pay(_ model: WxPaySignModel) {
        DispatchQueue.main.async {
            WXApi.startLog(by: .detail) { str in
                print("微信信息打印：\(str)")
            }
            let res = WXApi.registerApp(model.appid, universalLink: model.link)
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                WXApi.checkUniversalLinkReady { strp, result in
//                    print("微信自检：\(strp) -- \(result.success) -- \(result.errorInfo) -- \(result.suggestion)")
//                }
                if res {
                    let req = PayReq()
                    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
                    req.openID = model.appid
                    /* 商家向财付通申请的商家id */
                    req.partnerId = model.partnerid
                    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
                    req.prepayId = model.prepayid
                    /* 随机串，防重发 */
                    req.nonceStr = model.noncestr // UUID().uuidString
                    /* 时间戳，防重发 */
                    if let timestamp = UInt32(model.timestamp) {
                        req.timeStamp = timestamp
                    }// UInt32(Date.current.timeIntervalSince1970)
                    /* 商家根据财付通文档填写的数据和签名 */
                    req.package = model.package
                    /* 商家根据微信开放平台文档对数据做的签名 */
                    req.sign = model.signPay
                    //发送请求到微信，等待微信返回onResp
                    WXApi.send(req)
                }
            }
            
        }
        
    }
    
    func onResp(_ resp: BaseResp) {
        if let wxResp = resp as? PayResp {
            if wxResp.errCode == 0 {
                ProgressHUD.succeed("完成支付")
                let notification = Notification(name: .WXPaySUCCESSJUMP)
                NotificationCenter.default.post(notification)
            } else if wxResp.errCode == -1 {
                ProgressHUD.error("支付失败")
            } else if wxResp.errCode == -2 {
                ProgressHUD.error("取消支付")
            }
        }
    }
}


class AlipayTool: NSObject {
    static let instance = AlipayTool()
    
    func openURL(url: URL) -> Bool {
        AlipaySDK.defaultService().processOrder(withPaymentResult: url) { resultDic in
            let result = resultDic! as NSDictionary
            let returnCode:String = result["resultStatus"] as? String ?? ""
            switch  returnCode{
            case "6001":
                ProgressHUD.error("用户中途取消")
                break
            case "6002":
                ProgressHUD.error("网络连接出错")
                break
            case "4000":
                ProgressHUD.error("系统异常")
                break
            case "9000":
                ProgressHUD.succeed("完成支付")
                let notification = Notification(name: .ALIPAYSUCCESSJUMP)
                NotificationCenter.default.post(notification)
                break
            default:
                ProgressHUD.error("系统异常")
                break
            }
            
        }
        return true
    }
}
