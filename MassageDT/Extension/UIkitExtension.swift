//
//  UIkitExtension.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/17.
//

import Foundation
import UIKit
import SwiftUI

extension UIButton {
    func setGradientBackground(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds

        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        gradientLayer.render(in: context)

        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        setBackgroundImage(backgroundImage, for: .normal)
    }
}

extension UIView {
    func setGradientBackg(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        // 创建 CAGradientLayer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint

        // 将 CAGradientLayer 添加到视图的层级中
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIColor {
    convenience init?(gradient colors: [UIColor], locations: [NSNumber]? = nil) {
        guard colors.count > 1 else {
            return nil // 至少需要两种颜色
        }

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0.0)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        gradientLayer.render(in: context)

        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        let gradientColor = UIColor(patternImage: gradientImage)
        self.init(cgColor: gradientColor.cgColor)
    }
}

extension Color {
    // 通过十六进制字符串创建Color
    init(_ hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
