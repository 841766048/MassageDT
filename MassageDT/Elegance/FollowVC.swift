//
//  FollowVC.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/21.
//

import UIKit
import SwiftUI

class FollowVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的关注"
        self.view.backgroundColor = UIColor("#FAFAFA")
        
        let view = UIHostingController(rootView: FollowView()).view!
        view.frame = CGRect(x: 0, y: totalNavBarHeight, width: screenWidth, height: screenHeight - totalNavBarHeight - bottomSafeMargin)
        view.backgroundColor = .clear
        self.view.addSubview(view)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
