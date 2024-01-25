//
//  EleganceVC.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/20.
//

import UIKit
import SwiftUI

class EleganceVC: BaseViewController {
    
    lazy var viewModel: EleganceViewModel = {
        var viewModel: EleganceViewModel = EleganceViewModel()
        viewModel.followClickBlock = {
            self.navigationController?.pushViewController(FollowVC(), animated: true)
        }
        viewModel.voiceClickBlock = { model in
            self.navigationController?.pushViewController(UserDetailsVC(), animated: true)
        }
        viewModel.videoClickBlock = { model in
            self.navigationController?.pushViewController(VideoViewVC(), animated: true)
        }
        return viewModel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "风采"
    }
    override func initializeUIInfo() {
        super.initializeUIInfo()
        let eleganceView = UIHostingController(rootView: EleganceView(viewModel: viewModel)).view!
        eleganceView.frame = CGRect(x: 0, y: totalNavBarHeight, width: screenWidth, height: screenHeight - totalNavBarHeight - bottomSafeMargin  - 49)
        self.view.addSubview(eleganceView)
        // 延迟执行
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewModel.isLocate = true
            
            KeyWindowPopView.showPop {
                debugPrint("点击了OK")
            }
        }
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
