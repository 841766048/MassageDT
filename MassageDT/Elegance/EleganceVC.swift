//
//  EleganceVC.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/20.
//

import UIKit
import SwiftUI
import AdSupport
import AppTrackingTransparency

class EleganceVC: BaseViewController {
    
    lazy var viewModel: EleganceViewModel = {
        var viewModel: EleganceViewModel = EleganceViewModel()
        viewModel.followClickBlock = {
            if SystemCaching.full.count > 0 {
                KeyWindowPopView.showPop {
                    BaseTabBarControllerView.tab.selectedIndex = 1
                }
            } else {
                self.navigationController?.pushViewController(FollowVC(), animated: true)
            }
        }
        viewModel.voiceClickBlock = { model in
            if SystemCaching.full.count > 0 {
                KeyWindowPopView.showPop {
                    BaseTabBarControllerView.tab.selectedIndex = 1
                }
            } else {
                self.navigationController?.pushViewController(UserDetailsVC(iteModel: model), animated: true)
            }
        }
        viewModel.videoClickBlock = { model in
            if SystemCaching.full.count > 0 {
                KeyWindowPopView.showPop {
                    BaseTabBarControllerView.tab.selectedIndex = 1
                }
            } else {
                self.navigationController?.pushViewController(VideoViewVC(itemModel: model), animated: true)
            }
            
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
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        ATTrackingManager.requestTrackingAuthorization {[weak self] status in
            if status == .authorized {
                let idfa = ASIdentifierManager().advertisingIdentifier.uuidString
                SystemCaching.idfa = idfa
            }
        }
    }
    override func initializeUIInfo() {
        super.initializeUIInfo()
        let eleganceView = UIHostingController(rootView: EleganceView(viewModel: viewModel)).view!
        eleganceView.frame = CGRect(x: 0, y: totalNavBarHeight, width: screenWidth, height: screenHeight - totalNavBarHeight - bottomSafeMargin  - 49)
        self.view.addSubview(eleganceView)
        self.viewModel.isLocate = LocationManager.shared.hasLocationAuthorization()
        getDataSource()
        LocationManager.shared.startUpdatingLocation { locat in
            if let location = locat {
                self.viewModel.isLocate = true
                SystemCaching.longitude = "\(location.coordinate.longitude)"
                SystemCaching.latitude = "\(location.coordinate.latitude)"
            }
        }
    }
    
    func getDataSource() {
        NetWork.getEleganceData {[weak self] response in
            self?.viewModel.audio = response.audio
            self?.viewModel.video = response.video
            
        }
    }
    @objc func appWillEnterForeground() {
        self.viewModel.isLocate = LocationManager.shared.hasLocationAuthorization()
    }
}
