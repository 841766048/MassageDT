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
    
    @CachingConfig("idfa", defaultValue: "")
    static var idfa: String
    
    @CachingConfig("deviceToken", defaultValue: "")
    static var deviceToken: String
    
    @CachingConfig("isLogin", defaultValue: false)
    static var isLogin: Bool
    
    
    @CachingConfig("followList", defaultValue: ["1"])
    static var followList: [String]
    
    @CachingConfig("tdid", defaultValue: "")
    static var tdid: String
}
