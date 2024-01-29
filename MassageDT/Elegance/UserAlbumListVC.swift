//
//  UserAlbumListVC.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/23.
//

import UIKit
import SwiftUI

class UserAlbumListVC: BaseViewController {
    let iteModel: ElegantModel
    init(iteModel: ElegantModel) {
        self.iteModel = iteModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "用户相册"
        self.view.backgroundColor = UIColor("#FAFAFA")
        
        let view = UIHostingController(rootView: UserAlbumListView(iteModel: self.iteModel)).view!
        view.frame = CGRect(x: 0, y: totalNavBarHeight, width: screenWidth, height: screenHeight - totalNavBarHeight - bottomSafeMargin)
        self.view.addSubview(view)
    }
}
