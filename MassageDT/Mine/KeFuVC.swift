//
//  KeFuVC.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/22.
//

import UIKit

class KeFuVC: BaseViewController {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "客服"
        label.textColor = UIColor("#1E1E1E")
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "01055409966 "
        label.textColor = UIColor("#4E96EB")
        label.font = .systemFont(ofSize: 30, weight: .medium)
        return label
    }()
    lazy var copyButton: UIButton = {
        let copyBtn = UIButton()
        copyBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        copyBtn.setTitle("复制", for: .normal)
        copyBtn.addTarget(self, action: #selector(copyClick), for: .touchUpInside)
        return copyBtn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "客服"
    }
    override func initializeUIInfo() {
        super.initializeUIInfo()
        self.view.addSubview(titleLabel)
        self.view.addSubview(contentLabel)
        self.view.addSubview(copyButton)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(112)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(36)
        }
        copyButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(62)
            make.right.equalToSuperview().offset(-62)
            make.top.equalTo(contentLabel.snp.bottom).offset(28)
            make.height.equalTo(45)
        }
        copyButton.layoutIfNeeded()
        copyButton.setGradientBackground(colors: [UIColor("#77AEF7"), UIColor("#4D96EB")], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1,y: 1))
    }
    
    @objc func copyClick() {
        
    }
}
