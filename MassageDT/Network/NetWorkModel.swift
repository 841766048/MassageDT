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

struct StyleResponse: HandyJSON {
    var audio: [ElegantModel] = []
    var video: [ElegantModel] = []
}
