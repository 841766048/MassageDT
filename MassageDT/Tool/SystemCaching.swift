//
//  SystemCaching.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/17.
//

import Foundation

@propertyWrapper
struct CachingConfig<T> {
    let key: String
    let defaultValue: T
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}


struct SystemCaching {
    @CachingConfig("isFirstInstall", defaultValue: true)
    static var isFirstInstall: Bool
    
    @CachingConfig("phone", defaultValue: "")
    static var phone: String
    
    @CachingConfig("nickName", defaultValue: [])
    static var nickName: [String]
    
    
    @CachingConfig("idfa", defaultValue: "")
    static var idfa: String
    
    @CachingConfig("deviceToken", defaultValue: "")
    static var deviceToken: String
    
    @CachingConfig("isLogin", defaultValue: false)
    static var isLogin: Bool
    
    /// 关注列表
    @CachingConfig("followList", defaultValue: [])
    static var followList: [String]
    /// 拉黑列表
    @CachingConfig("blackList", defaultValue: [])
    static var blackList: [String]
    
    @CachingConfig("latitude", defaultValue: "")
    static var latitude: String // 纬度
    
    @CachingConfig("longitude", defaultValue: "")
    static var longitude: String // 经度
    
    
    @CachingConfig("key", defaultValue: "")
    static var key: String // key
    
    
    @CachingConfig("kefu", defaultValue: "")
    static var kefu: String // key
    
    @CachingConfig("tab", defaultValue: "")
    static var tab: String // key
    
    
    @CachingConfig("full", defaultValue: "")
    static var full: String // 
    
    @CachingConfig("find_url", defaultValue: "")
    static var find_url: String

    static func clearLogin() {
        SystemCaching.key = ""
        SystemCaching.kefu = ""
        SystemCaching.find_url = ""
        SystemCaching.tab = ""
        SystemCaching.full = ""
        SystemCaching.isLogin = false
    }
    
}

var glaModel: RetrievePermissionInfoModel? = nil
