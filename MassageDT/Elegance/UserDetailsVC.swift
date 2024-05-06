//
//  UserDetailsVC.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/22.
//

import UIKit
import SwiftUI

class UserDetailsVC: BaseViewController {
    lazy var viewModel: UserDetailsViewModel = {
        let viewM = UserDetailsViewModel()
        viewM.followListClick = {
            self.navigationController?.pushViewController(FollowVC(), animated: true)
        }
        viewM.serverClick = {
            if SystemCaching.isLogin {
                self.navigationController?.pushViewController(ReservationServiceVC(iteModel: self.iteModel), animated: true)
            } else {
                topViewController()?.navigationController?.pushViewController(LoginVC(), animated: true)
                
            }
            
        }
        viewM.albumListClick = {
            self.navigationController?.pushViewController(UserAlbumListVC(iteModel: self.iteModel), animated: true)
        }
        return viewM
    }()
    let iteModel: ElegantModel
    init(iteModel: ElegantModel) {
        self.iteModel = iteModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.itemModel = iteModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "用户详情"
        self.view.backgroundColor = UIColor("#FAFAFA")
        let view = UIHostingController(rootView: UserDetailsView(viewModel: viewModel)).view!
        view.frame = CGRect(x: 0, y: totalNavBarHeight, width: screenWidth, height: screenHeight - totalNavBarHeight - bottomSafeMargin)
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
