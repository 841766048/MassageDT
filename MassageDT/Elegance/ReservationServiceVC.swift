//
//  ReservationServiceVC.swift
//  MassageDT
//  
//  Created by wealon on 2024.
//  MassageDT.
//  
    

import UIKit
import SwiftUI

class ReservationServiceVC: BaseViewController {
    lazy var viewModel: ReservationServiceViewModel = {
        let viewM = ReservationServiceViewModel()
        viewM.payClick = {
            
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
        self.title = "预约服务"
        self.view.backgroundColor = UIColor("#FAFAFA")
        let view = UIHostingController(rootView: ReservationServiceView(viewModel: viewModel)).view!
        view.frame = CGRect(x: 0, y: totalNavBarHeight, width: screenWidth, height: screenHeight - totalNavBarHeight - bottomSafeMargin)
        self.view.addSubview(view)
        NotificationCenter.default.addObserver(self, selector: #selector(payJumpSuccess), name: .WXPaySUCCESSJUMP, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(payJumpSuccess), name: .ALIPAYSUCCESSJUMP, object: nil)
    }
    @objc func payJumpSuccess() {
        print("立即预约")
        self.navigationController?.pushViewController(ReservationServiceSuccessVC(iteModel: self.iteModel), animated: true)
    }
}
