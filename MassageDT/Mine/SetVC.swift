//
//  SetVC.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/22.
//

import UIKit
import SwiftUI

class SetVC: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        let setView = UIHostingController(rootView: SetView()).view!
        setView.frame =  CGRect(x: 0, y: totalNavBarHeight, width: screenWidth, height: screenHeight - totalNavBarHeight - bottomSafeMargin  - 49)
        self.view.addSubview(setView)
    }
}
