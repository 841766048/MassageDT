//
//  ReservationServiceSuccessVC.swift
//  MassageDT
//  
//  Created by wealon on 2024.
//  MassageDT.
//  
    

import UIKit
import SwiftUI

class ReservationServiceSuccessVC: BaseViewController {
    lazy var viewModel: ReservationServiceSuccessViewModel = {
        let viewM = ReservationServiceSuccessViewModel()
        viewM.okClick = {
            self.navigationController?.popToRootViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                BaseTabBarControllerView.tab.selectedIndex = 2
            }
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
        let view = UIHostingController(rootView: ReservationServiceSuccessView(viewModel: viewModel)).view!
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
