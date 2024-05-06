//
//  NetWorkModel.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/26.
//

import Foundation
import HandyJSON

struct BaseResponse<T: HandyJSON>: HandyJSON {
    var code: Int = 0
    var msg: String = ""
    var data: T?
}

extension Bool: HandyJSON {}


struct PerformCodeLoginModel: HandyJSON {
    var key: String = ""
    var kefu: String = ""
    var tab: String = ""
}

struct BoxResult: HandyJSON {
    var url: String = ""
    var width: Double = 0.0
    var height: Double = 0.0
}

struct RetrievePermissionInfoModel: HandyJSON {
    var prelogin: String = "" //
    var full: String = ""
    var tab: Int = 0
    var rank: Int = 0
    var box: [BoxResult] = []
    var kefu: String = ""
    var find_url: String = ""
    var quan: Int = 0
    var my_account: String = ""
    var my_need_url: String = ""
    var chat_url: String = ""
    var pconfs: [PconfsModel] = []
}

struct PconfsModel: HandyJSON {
    var type: String = ""
    var def: String = ""
}

struct PerformAccountLogoutTips: HandyJSON {
    var tip: String = ""
}

struct ElegantModel: HandyJSON {
    var id: String = ""
    var nickname: String = ""
    var userTags: [String] = []
    var cityName: String = ""
    var Albums: [String] = []
    var userAvatar: String = ""
    var audioSrc: String = ""
    var videoSrc: String = ""
    var type: String = ""
    var services: [ElegantServerModel] = []
    var userAlbums: [String] {
        return self.Albums
    }
    var partUserAlbums: [String] {
        if self.Albums.count > 9 {
            return Array(self.Albums.prefix(9))
        }
        return self.Albums
    }
}

struct ElegantServerModel: HandyJSON {
    var id: Int?
    var serviceName: String?
    var serviceIcon: String?
    var servicePrice: Double?
}

struct StyleResponse: HandyJSON {
    var audio: [ElegantModel] = []
    var video: [ElegantModel] = []
}



struct WxPayModel: HandyJSON {
    var order_sn: String = ""
    var type: String = ""
    var id: String = ""
    var sign: WxPaySignModel?
}


struct WxPaySignModel: HandyJSON {
    var appid: String = ""
    var partnerid: String = ""
    var prepayid: String = ""
    var package: String = ""
    var noncestr: String = ""
    var timestamp: String = ""
    var package_: String = ""
    var link: String = ""
    var signPay: String = ""
    var orderId: String = ""
}


struct AliPayModel: HandyJSON {
    var order_sn: String = ""
    var type: String = ""
    var id: String = ""
    var sign: String = ""
}
