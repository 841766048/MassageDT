//
//  PrivacyPopUpView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/17.
//

import UIKit
import YYText
import AutoInch
import SnapKit
import JFPopup
import UIColor_Hex_Swift
import Network

class PrivacyPopUpView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "欢迎使用"
        label.textColor = UIColor("#1E1E1E")
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    lazy var contentLabel: YYLabel = {
        let label = YYLabel()
        label.textAlignment = .center
        label.preferredMaxLayoutWidth = screenWidth - 38.auto()*2
        label.textColor = UIColor("#3C3C3C")
        label.font = .systemFont(ofSize: 15)
        let textStr = "请您充分阅读《用户协议》和《隐私政策》，我们非常注重您的隐私和个人信息保护。在您使用的过程中，我们会对您的部分个人信息进行收集和使用。未经您同意，我们不会出售和共享您的信息。您可以查询，更正，删除您的个人信息，我们提供了注销账号和拉黑举报功能。"
        var searchRange = NSRange(location: 0, length: textStr.utf16.count)

        
        var agreement_ranges: [NSRange] = []
        while searchRange.location != NSNotFound {
            let range = (textStr as NSString).range(of: "《用户协议》", options: .caseInsensitive, range: searchRange)
               if range.location != NSNotFound {
                   agreement_ranges.append(range)
                   searchRange.location = range.upperBound
                   searchRange.length = textStr.utf16.count - range.upperBound
               } else {
                   break
               }
        }
        
        var policy_searchRange = NSRange(location: 0, length: textStr.utf16.count)
        var policy_ranges: [NSRange] = []
        while policy_searchRange.location != NSNotFound {
            let range = (textStr as NSString).range(of: "《隐私政策》", options: .caseInsensitive, range: policy_searchRange)
               if range.location != NSNotFound {
                   policy_ranges.append(range)
                   policy_searchRange.location = range.upperBound
                   policy_searchRange.length = textStr.utf16.count - range.upperBound
               } else {
                   break
               }
        }

        let attriStr = NSMutableAttributedString(string: textStr)
        attriStr.yy_color = UIColor("#3C3C3C")
        attriStr.yy_font = .systemFont(ofSize: 15)
        attriStr.yy_alignment = .center
       
        let highlight_agreement = YYTextHighlight()
        highlight_agreement.tapAction = { _, _, _, _ in
            debugPrint("用户协议")
            let vc = ProtocolPolicyVC()
            vc.title = "用户协议"
            vc.urlStr = "https://dtpubs.51quanmo.cn/AB/User.Agreement.html"
            topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
        let highlight_policy = YYTextHighlight()
        highlight_policy.tapAction = { _, _, _, _ in
            debugPrint("隐私政策")
            let vc = ProtocolPolicyVC()
            vc.title = "隐私政策"
            vc.urlStr =  "https://dtpubs.51quanmo.cn/AB/Privacy.Policy.html"
            topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
        attriStr.yy_lineSpacing = 10
        for range in agreement_ranges {
            attriStr.yy_setColor(UIColor("#4D96EB"), range: range)
            attriStr.yy_setTextHighlight(highlight_agreement, range: range)
        }
        for range in policy_ranges {
            attriStr.yy_setColor(UIColor("#4272D7"), range: range)
            attriStr.yy_setTextHighlight(highlight_policy, range: range)
        }

        label.numberOfLines = 0
        label.attributedText = attriStr
        return label
    }()
    
    lazy var disagreedButton: UIButton = {
        let button = UIButton()
        button.setTitle("不同意", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(UIColor("#1E1E1E"), for: .normal)
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor("#4D96EB").cgColor
        button.layer.cornerRadius = 7.auto()
        button.addTarget(self, action: #selector(disagreedButtonClick), for: .touchUpInside)
        return button
    }()
    
    lazy var agreedButton: UIButton = {
        let button = UIButton()
        button.setTitle("同意", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(UIColor("#FFFFFF"), for: .normal)
        button.layer.cornerRadius = 7.auto()
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(agreedButtonClick), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth - 25*2, height: 290.auto()))
        initWithUI()
        self.backgroundColor = .white
        self.layer.cornerRadius = 9.auto()
        self.layer.masksToBounds = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initWithUI() {
        self.addSubview(titleLabel)
        self.addSubview(contentLabel)
        self.addSubview(disagreedButton)
        self.addSubview(agreedButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20.auto())
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13.auto())
            make.right.equalToSuperview().offset(-13.auto())
            make.top.equalTo(titleLabel.snp.bottom).offset(14.auto())
        }
        
        
        disagreedButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19.auto())
            make.top.equalTo(contentLabel.snp.bottom).offset(31.auto())
            make.bottom.equalToSuperview().offset(-28.auto())
            make.width.equalTo(132.auto())
            make.height.equalTo(42.auto())
        }
        
        
        agreedButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-19.auto())
            make.top.equalTo(contentLabel.snp.bottom).offset(31.auto())
            make.bottom.equalToSuperview().offset(-28.auto())
            make.width.equalTo(132.auto())
            make.height.equalTo(42.auto())
        }
        agreedButton.layoutIfNeeded()
        agreedButton.setGradientBackground(colors: [UIColor("#4D96EB"), UIColor("#77AEF7")], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
    }
    
    @objc func disagreedButtonClick() {
        exit(0)
    }
    
    @objc func agreedButtonClick() {
        TalkingDataSDK.initSDK("4A62E26FFBD2441591FDE9FA39A18140", channelId: "AppStore", custom: "")
        TalkingDataSDK.startA()
        SystemCaching.isFirstInstall = false
        RootViewToggle.default.replaceRootView()
    }
}


class FirstInstallVC: BaseViewController {
    
    lazy var bgImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "launchScreen")
        return img
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initWithUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func initWithUI() {
        self.view.addSubview(self.bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let view = PrivacyPopUpView()
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

    }
}
