//
//  SystemTool.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/17.
//

import Foundation


func debugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    print(items, separator: separator, terminator: terminator)
    #endif
}
