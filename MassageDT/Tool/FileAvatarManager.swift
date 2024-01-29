//
//  FileAvatarManager.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/27.
//

import Foundation
import UIKit

class AvatarManager {
    
    static func saveAvatar(image: UIImage, forAccount account: String) {
        // 获取沙盒中的Documents目录路径
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            // 创建账号对应的头像文件夹
            let accountFolderURL = documentsDirectory.appendingPathComponent(account)
            do {
                try FileManager.default.createDirectory(at: accountFolderURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating account folder: \(error)")
                return
            }
            
            // 保存头像图片到文件夹中
            let avatarURL = accountFolderURL.appendingPathComponent("avatar.png")
            if let imageData = image.pngData() {
                do {
                    try imageData.write(to: avatarURL)
                } catch {
                    print("Error saving avatar: \(error)")
                }
            }
        }
    }
    
    static func loadAvatar(forAccount account: String) -> UIImage? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            // 获取账号对应的头像文件夹
            let accountFolderURL = documentsDirectory.appendingPathComponent(account)
            let avatarURL = accountFolderURL.appendingPathComponent("avatar.png")
            
            // 从文件夹中加载头像图片
            if let imageData = try? Data(contentsOf: avatarURL),
               let avatarImage = UIImage(data: imageData) {
                return avatarImage
            }
        }
        return nil
    }
}
