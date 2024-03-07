//
//  KeyWindowPopView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/21.
//

import UIKit
import UIColor_Hex_Swift

class KeyWindowPopView: UIView {
    lazy var closeButton: UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(dismissAnimated), for: .touchUpInside)
        return closeBtn
    }()
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.setTitle("好的", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor("#4D96EB")
        button.addTarget(self, action: #selector(okClick), for: .touchUpInside)
        button.layer.cornerRadius = 9
        button.layer.masksToBounds = true
        return button
    }()
    lazy var mesageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = SystemCaching.full.count > 0 ? SystemCaching.full : "当前服务正忙\n请稍后再试"
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor("#1E1E1E")
        return label
    }()
    
    var okBlock: (() -> ())? = nil
    
    static func showPop(okBlock: (() -> ())? = nil) {
        let view = KeyWindowPopView(frame: .zero)
        view.okBlock = okBlock
        view.show()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUIInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeUIInfo() {
        self.addSubview(self.closeButton)
        self.addSubview(self.mesageLabel)
        self.addSubview(self.okButton)
        
        closeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        }
        
        mesageLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(37)
            make.right.equalToSuperview().offset(-37)
            make.top.equalToSuperview().offset(50)
        }
        
        okButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(37)
            make.right.equalToSuperview().offset(-37)
            make.top.equalTo(mesageLabel.snp.bottom).offset(40)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-25)
        }
    }
    
    func show() {
        let background = UIView(frame: UIScreen.main.bounds)
        background.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        
        let backgroundBtn = UIButton()
        backgroundBtn.backgroundColor = UIColor.clear
//        backgroundBtn.addTarget(self, action: #selector(dismissAnimated), for: .touchUpInside)
        background.addSubview(backgroundBtn)
        backgroundBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        background.addSubview(self)
        self.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
        }
        self.backgroundColor = .white
        self.layoutIfNeeded()
        self.layer.cornerRadius = 9
        self.layer.masksToBounds = true
        self.transform = CGAffineTransformMakeScale(0.1, 0.1)
        if let window = keyWindow {
            window.addSubview(background)
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1.0
                self.transform = CGAffineTransformIdentity;
            }
        }
        
        
    }
    
    @objc func dismissAnimated() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
            self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        }) { finished in
            self.superview?.removeFromSuperview()
        }
    }
    
    @objc func okClick() {
        self.dismissAnimated()
        self.okBlock?()
    }
}
