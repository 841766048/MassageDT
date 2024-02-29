//
//  NetWork.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/25.
//

import Foundation
import HandyJSON
import ProgressHUD
import CommonCrypto
import Alamofire


let baseURL = "https://dtlvision.51quanmo.cn/"

struct NetWorkConfig: HandyJSON {
    let qeraumd = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    let c1ued5 = "iPhone"
    let nequce = UIDevice.current.model
    let unfs = SystemCaching.idfa
    let nequce_5mked = SystemCaching.deviceToken
    let appname = "dtlvision"
    let signature: String? = generateMD5Signature()
    
    static func generateMD5Signature() -> String? {
        // 获取当前小时数
        let currentHour = Calendar.current.component(.hour, from: Date())
        // 构建要签名的字符串
        let signatureString = "dtlvision" + String(format: "%02d", currentHour)

        // 计算MD5签名
        guard let data = signatureString.data(using: .utf8) else {
            return nil
        }

        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = data.withUnsafeBytes { (body: UnsafeRawBufferPointer) in
            CC_MD5(body.baseAddress, CC_LONG(data.count), &digest)
//            CC_SHA256(body.baseAddress, CC_LONG(data.count), &digest)
        }

        // 将MD5签名转换为字符串
        let md5Signature = digest.map { String(format: "%02hhx", $0) }.joined()
        return md5Signature
    }

}

func getCommonParameter() -> [String: String] {
    if var dict = NetWorkConfig().toJSON() as? [String: String] {
        dict["5nun"] = TalkingDataSDK.getDeviceId()
        dict["1dg"] = SystemCaching.longitude
        dict["1s5"] = SystemCaching.latitude
        return dict
    }
    return [:]
}

func POST(path: String, params: [String:String]) -> DataRequest {
    print("===>参数POST\(params)，path = \(path)")
    return AF
        .request(baseURL + path,
                 method: .post,
                 parameters: params,
                 encoder:  URLEncodedFormParameterEncoder(destination: .queryString),
                 headers: [:],
               requestModifier: {$0.timeoutInterval = 15})
}

func GET(path: String, params: [String:String], baseURL: String = baseURL) -> DataRequest {
    print("===>参数GET\(params)，path = \(path)")
    return AF
        .request(baseURL + path,
                 method: .get,
                 parameters: params,
                 encoder:  URLEncodedFormParameterEncoder(destination: .queryString),
                 headers: [:],
               requestModifier: {$0.timeoutInterval = 15})
}




class NetWork {
    
    /// 发送验证码
    /// - Parameters:
    ///   - mobile: 手机号
    ///   - completionHandler: 回调
    static func sendVerificationCode(_ mobile: String, completionHandler: @escaping (BaseResponse<Bool>?) -> Void) {
        // 构建请求体数据
        var parameters: [String: String] = getCommonParameter()
        parameters["mobile"] = mobile
        ProgressHUD.animate()
        POST(path: "sign/?a=index", params: parameters)
            .responseString { response in
                ProgressHUD.dismiss()
                switch response.result {
                case let .success(res):
                    let model = BaseResponse<Bool>.deserialize(from: res)
                    completionHandler(model)
                case let .failure(error):
                    print("err = \(error)")
                }
            }
    }
    
    
    /// 验证码登录
    /// - Parameters:
    ///   - mobile: 手机号
    ///   - code: 验证码
    ///   - completionHandler: 回调
    static func performCodeLogin(_ mobile: String, code: String, completionHandler: @escaping (PerformCodeLoginModel?) -> Void) {
        var parameters: [String: String] = getCommonParameter()
        parameters["mobile"] = mobile
        parameters["code"] = code
        ProgressHUD.animate()
        POST(path: "sign/?a=index", params: parameters)
            .responseString { response in
                switch response.result {
                case let .success(res):
                    let model = BaseResponse<PerformCodeLoginModel>.deserialize(from: res)
                    if model?.code == 200 {
                        ProgressHUD.dismiss()
                        completionHandler(model?.data)
                    } else {
                        ProgressHUD.error(model?.msg ?? "")
                    }
                    
                case let .failure(error):
                    ProgressHUD.dismiss()
                    print("err = \(error)")
                }
            }
    }
    
    /// 一键登录
    /// - Parameters:
    ///   - token: 闪验返回的token
    ///   - completionHandler: 回调
    static func performOneClickLogin(_ token: String, completionHandler: @escaping (PerformCodeLoginModel?) -> Void) {
        var parameters: [String: String] = getCommonParameter()
        parameters["result"] = "{\"token\":\"\(token)\"}"
        ProgressHUD.animate()
        POST(path: "sign/?a=index", params: parameters)
            .responseString { response in
                ProgressHUD.dismiss()
                switch response.result {
                case let .success(res):
                    let model = BaseResponse<PerformCodeLoginModel>.deserialize(from: res)
                    completionHandler(model?.data)
                case let .failure(error):
                    print("err = \(error)")
                }
            }
    }
    
    /// 获取配置信息
    /// - Parameter completionHandler: 回调
    static func retrievePermissionInfo(completionHandler: @escaping (RetrievePermissionInfoModel?) -> Void) {
        var parameters: [String: String] = getCommonParameter()
        parameters["key"] = SystemCaching.key
        ProgressHUD.animate()
        POST(path: "sign/?a=my", params: parameters)
            .responseString { response in
                ProgressHUD.dismiss()
                switch response.result {
                case let .success(res):
                    let model = BaseResponse<RetrievePermissionInfoModel>.deserialize(from: res)
                    SystemCaching.full = model?.data?.full ?? ""
                    completionHandler(model?.data)
                case let .failure(error):
                    print("err = \(error)")
                }
            }
    }
    
    /// 退出登录
    /// - Parameter completionHandler: 回调
    static func logOut(completionHandler: @escaping (Bool) -> Void) {
        var parameters: [String: String] = getCommonParameter()
        parameters["key"] = SystemCaching.key
        ProgressHUD.animate()
        POST(path: "sign/?a=index", params: parameters)
            .responseString { response in
                ProgressHUD.dismiss()
                switch response.result {
                case let .success(res):
                    let model = BaseResponse<Bool>.deserialize(from: res)
                    completionHandler(model?.code == 200)
                case let .failure(error):
                    print("err = \(error)")
                }
            }
    }
    
    /// 获取注销账号文案
    /// - Parameter completionHandler: 回调
    static func performAccountLogoutText(completionHandler: @escaping (String) -> Void) {
        var parameters: [String: String] = getCommonParameter()
        parameters["key"] = SystemCaching.key
        parameters["cancel_member"] = "1"
        ProgressHUD.animate()
        GET(path: "sign/?a=index", params: parameters)
            .responseString { response in
                ProgressHUD.dismiss()
                switch response.result {
                case let .success(res):
                    let model = BaseResponse<PerformAccountLogoutTips>.deserialize(from: res)
                    completionHandler(model?.data?.tip ?? "")
                case let .failure(error):
                    print("err = \(error)")
                    completionHandler("")
                }
            }
    }
    
    /// 注销账号
    /// - Parameter completionHandler: 回调
    static func performAccountLogout(completionHandler: @escaping (Bool) -> Void) {
        var parameters: [String: String] = getCommonParameter()
        parameters["key"] = SystemCaching.key
        parameters["cancel_member"] = "1"
        ProgressHUD.animate()
        POST(path: "sign/?a=index", params: parameters)
            .responseString { response in
                ProgressHUD.dismiss()
                switch response.result {
                case let .success(res):
                    let model = BaseResponse<Bool>.deserialize(from: res)
                    completionHandler(model?.code == 200)
                case let .failure(error):
                    print("err = \(error)")
                    completionHandler(false)
                }
            }
    }
    
    static func getEleganceData(completionHandler: @escaping (StyleResponse) -> Void) {
        GET(path: "/style.json", params: [:], baseURL: "https://dtpubs.51quanmo.cn")
            .response { response in
                ProgressHUD.dismiss()
                switch response.result {
                case .success(let success):
                    if let data = success {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            if let model = StyleResponse.deserialize(from: jsonString) {
                                UserFollowBlacklist.default.userData = model
                                var audio_dataSource: [ElegantModel] = []
                                let audio = model.audio.filter({ item in
                                    return !SystemCaching.blackList.contains(item.id)
                                })
                                audio_dataSource.append(contentsOf: audio)
                                
                                var video_dataSource: [ElegantModel] = []
                                let video = model.video.filter({ item in
                                    return !SystemCaching.blackList.contains(item.id)
                                })
                                video_dataSource.append(contentsOf: video)
                                let dataModel = StyleResponse(audio: audio_dataSource, video: video_dataSource)
                                completionHandler(dataModel)
                            }
                        }
                    }
                case .failure(_):
                    break
                }
            }
    }
    
    
    static func blackRequest(msg: String, completionHandler: @escaping (Bool) -> Void) {
        var parameters: [String: String] = getCommonParameter()
        parameters["key"] = SystemCaching.key
        parameters["any_other_key"] = msg
        ProgressHUD.animate()
        POST(path: "sign/?a=api", params: parameters)
            .responseString { response in
                switch response.result {
                case let .success(res):
                    let model = BaseResponse<Bool>.deserialize(from: res)
                    if model?.code == 200 {
                        completionHandler(model?.code == 200)
                    } else {
                        ProgressHUD.dismiss()
                    }
                case let .failure(error):
                    ProgressHUD.dismiss()
                }
            }
    }
}

class UserFollowBlacklist {
    static let `default` = UserFollowBlacklist()
    
    var userData: StyleResponse?
    
    var followList: [ElegantModel] {
        var dataSource: [ElegantModel] = []
        if let audio = userData?.audio.filter({ model in
            return SystemCaching.followList.contains(model.id)
        }) {
            dataSource.append(contentsOf: audio)
        }
        if let video = userData?.video.filter({ model in
            return SystemCaching.followList.contains(model.id)
        }) {
            dataSource.append(contentsOf: video)
        }
        return dataSource
    }
    
    var blackList: [ElegantModel] {
        var dataSource: [ElegantModel] = []
        if let audio = userData?.audio.filter({ model in
            return SystemCaching.blackList.contains(model.id)
        }) {
            dataSource.append(contentsOf: audio)
        }
        if let video = userData?.video.filter({ model in
            return SystemCaching.blackList.contains(model.id)
        }) {
            dataSource.append(contentsOf: video)
        }
        return dataSource
    }
}
