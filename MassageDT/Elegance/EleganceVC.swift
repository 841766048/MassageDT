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
            self.navigationController?.pushViewController(UserDetailsVC(iteModel: model), animated: true)
        }
        viewModel.videoClickBlock = { model in
            self.navigationController?.pushViewController(VideoViewVC(itemModel: model), animated: true)
        }
        return viewModel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "风采"
        RootViewToggle.default.$updateElegance
            .dropFirst()
            .sink {[weak self] _ in
                self?.getDataSource()
            }
            .store(in: &disposeBag)
    }
    override func initializeUIInfo() {
        super.initializeUIInfo()
        let eleganceView = UIHostingController(rootView: EleganceView(viewModel: viewModel)).view!
        eleganceView.frame = CGRect(x: 0, y: totalNavBarHeight, width: screenWidth, height: screenHeight - totalNavBarHeight - bottomSafeMargin  - 49)
        self.view.addSubview(eleganceView)
        self.viewModel.isLocate = LocationManager.shared.hasLocationAuthorization()
        getDataSource()
    }
    
    func getDataSource() {
        NetWork.getEleganceData {[weak self] response in
            self?.viewModel.audio = response.audio
            self?.viewModel.video = response.video
            if SystemCaching.full.count > 0 {
                KeyWindowPopView.showPop {
                    BaseTabBarControllerView.tab.selectedIndex = 1
                }
            }
        }
    }

}
