//
//  UserAlbumListVC.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/23.
//

import UIKit
import SwiftUI

class UserAlbumListVC: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "用户相册"
        self.view.backgroundColor = UIColor("#FAFAFA")
        
        let view = UIHostingController(rootView: UserAlbumListView()).view!
        view.frame = CGRect(x: 0, y: totalNavBarHeight, width: screenWidth, height: screenHeight - totalNavBarHeight - bottomSafeMargin)
        self.view.addSubview(view)
    }
}
