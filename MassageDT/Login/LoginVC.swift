//
//  LoginVC.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/18.
//

import UIKit
import YYText
import ProgressHUD
import CL_ShanYanSDK

class LoginVC: BaseViewController {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "登录/注册"
        label.textColor = UIColor("#1F1F1F")
        label.font = .systemFont(ofSize: 25, weight: .medium)
        return label
    }()
    
    lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.backgroundColor = UIColor("#F8FAFD")
        textField.placeholder = "请输入手机号"
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 65.auto(), height: 55.auto()))
        
        let centerY = 55.auto()/2.0
        
        
        let label = UILabel()
        label.text = "+86"
        label.frame = CGRect(x: 11.auto(), y: centerY - 15.auto()/2.0, width: 30.auto(), height: 15.auto())
        label.textColor = UIColor("#1E1E1E")
        leftView.addSubview(label)
        //
        let lin = UILabel()
        lin.backgroundColor = UIColor("#787878")
        lin.frame = CGRectMake(65.auto() - 15.auto(), 13.auto(), 0.5.auto(), 29.auto())
        leftView.addSubview(lin)
        
        // 将左侧图标设置为 leftView
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 10
        textField.font = .systemFont(ofSize: 18)
        textField.layer.masksToBounds = true
        return textField
    }()
    
    lazy var numberTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 18)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy var codeButton: UIButton = {
        let codeBtn = UIButton()
        codeBtn.titleLabel?.font = .systemFont(ofSize: 18)
        codeBtn.setTitle("获取验证码", for: .normal)
        codeBtn.setTitleColor(.white, for: .normal)
        codeBtn.backgroundColor = UIColor("#6FA5F6")
        codeBtn.addTarget(self, action: #selector(startCountdown), for: .touchUpInside)
        
        return codeBtn
    }()
    // 定时器
    var timer: Timer?
    // 倒计时时长
    var countdownSeconds = 60
    lazy var agreePrivacyAgreementButton: UIButton = {
        let select_btn = UIButton()
        select_btn.setImage(UIImage(named: "no_select"), for: .normal)
        select_btn.setImage(UIImage(named: "select"), for: UIControl.State.selected)
        select_btn.addTarget(self, action: #selector(agreePrivacyAgreement), for: UIControl.Event.touchUpInside)
        return select_btn
    }()
    lazy var one_agreePrivacyAgreementButton: UIButton = {
        let select_btn = UIButton()
        select_btn.setImage(UIImage(named: "no_select"), for: .normal)
        select_btn.setImage(UIImage(named: "select"), for: UIControl.State.selected)
        select_btn.addTarget(self, action: #selector(one_agreePrivacyAgreementButtonClick), for: UIControl.Event.touchUpInside)
        return select_btn
    }()
    lazy var policyView: UIView = {
        let view = UIView()
        view.addSubview(self.agreePrivacyAgreementButton)
        self.agreePrivacyAgreementButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(16.auto())
            make.centerY.equalToSuperview()
        }
        let content_text = YYLabel()
        content_text.textColor = UIColor("#9D9D9D")
        content_text.font = .systemFont(ofSize: 12)
        let textStr = "同意《用户协议》和《隐私政策》"
        let range01 = (textStr as NSString).range(of: "《用户协议》", options: .caseInsensitive)
        let range02 = (textStr as NSString).range(of: "《隐私政策》", options: .caseInsensitive)
        let attriStr = NSMutableAttributedString(string: textStr)
        attriStr.yy_color = UIColor("#6E6E6E")
        attriStr.yy_font = .systemFont(ofSize: 14)
        attriStr.yy_setColor(UIColor("#5095EB"), range: range01)
        attriStr.yy_setColor(UIColor("#5095EB"), range: range02)
        let highlight01 = YYTextHighlight()
        highlight01.tapAction = {[weak self] _, _, _, _ in
            debugPrint("用户协议")
            let vc = ProtocolPolicyVC()
            vc.urlStr = "https://bai.tongchengjianzhi.cn/ba/ab/yhxy.html"
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        let highlight02 = YYTextHighlight()
        highlight02.tapAction = {[weak self] _, _, _, _ in
            debugPrint("隐私政策")
            let vc = ProtocolPolicyVC()
            vc.urlStr = "https://bai.tongchengjianzhi.cn/ba/ab/yszc.html"
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        attriStr.yy_setTextHighlight(highlight01, range: range01)
        attriStr.yy_setTextHighlight(highlight02, range: range02)
        content_text.numberOfLines = 0
        content_text.attributedText = attriStr
        view.addSubview(content_text)
        content_text.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.agreePrivacyAgreementButton.snp.right).offset(6.auto())
            make.right.equalToSuperview()
        }
        return view
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("登录", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = true
        return button
    }()
    var isPrivacyAgreed = false {
        didSet {
            self.one_agreePrivacyAgreementButton.isSelected = isPrivacyAgreed
            self.agreePrivacyAgreementButton.isSelected = isPrivacyAgreed
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberOneClickLogin()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.agreePrivacyAgreementButton.isSelected = self.isPrivacyAgreed
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func initializeUIInfo() {
        self.view.setGradientBackg(colors: [UIColor("#E1EEFF"), UIColor("#F3F5FC")], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
        self.view.addSubview(self.titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26.auto())
            make.top.equalToSuperview().offset(121.auto())
        }
        
        let selectTypeView = LoginTypSelectView(type: .verifCodeLogin, oneClickBlock:  {[weak self] in
            self?.phoneNumberOneClickLogin()
        })
        
        self.view.addSubview(selectTypeView)
        selectTypeView.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(56.auto())
        }
        
        self.view.addSubview(self.phoneTextField)
        phoneTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25.auto())
            make.right.equalToSuperview().offset(-25.auto())
            make.top.equalTo(selectTypeView.snp.bottom).offset(47.auto())
            make.height.equalTo(55.auto())
        }
        
        let codeView = UIView()
        codeView.layer.cornerRadius = 10
        codeView.layer.masksToBounds = true
        codeView.backgroundColor = UIColor("#F8FAFD")
        self.view.addSubview(codeView)
        codeView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25.auto())
            make.right.equalToSuperview().offset(-25.auto())
            make.top.equalTo(phoneTextField.snp.bottom).offset(20.auto())
            make.height.equalTo(55.auto())
        }
        
        codeView.addSubview(self.numberTextField)
        codeView.addSubview(self.codeButton)
        numberTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10.auto())
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-125.auto())
        }
        codeButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.equalTo(125.auto())
            make.top.bottom.equalToSuperview()
        }
        
        view.addSubview(policyView)
        policyView.snp.makeConstraints { make in
            make.top.equalTo(codeView.snp.bottom).offset(25.auto())
            make.left.equalToSuperview().offset(25.auto())
            make.right.equalToSuperview()
            make.height.equalTo(19.auto())
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25.auto())
            make.right.equalToSuperview().offset(-25.auto())
            make.top.equalTo(policyView.snp.bottom).offset(65.auto())
            make.height.equalTo(50.auto())
        }
        loginButton.layoutIfNeeded()
        loginButton.setGradientBackground(colors: [UIColor("#4D96EB"), UIColor("#77AEF7")], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
    }
    
    
    override func navigationBarHiden() -> Bool {
        return true
    }
    
    @objc func agreePrivacyAgreement() {
        self.isPrivacyAgreed = !self.isPrivacyAgreed
    }
    @objc func one_agreePrivacyAgreementButtonClick() {
        self.isPrivacyAgreed = !self.isPrivacyAgreed
    }
    
    // 点击按钮开始倒计时
    @objc func startCountdown() {
        
        guard let phone = self.phoneTextField.text else {
            ProgressHUD.failed("请填写手机号")
            return
        }
        if phone.count == 0 {
            ProgressHUD.failed("请填写手机号")
            return
        }
        
        
        // 禁用按钮防止重复点击
        codeButton.isEnabled = false
        
        // 启动定时器，每秒更新倒计时
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    // 更新倒计时
    @objc func updateCountdown() {
        guard countdownSeconds > 0 else {
            // 倒计时结束，恢复按钮状态
            codeButton.isEnabled = true
            timer?.invalidate()
            timer = nil
            return
        }
        
        // 更新按钮标题，显示倒计时
        codeButton.setTitle("重新获取(\(countdownSeconds)s)", for: .normal)
        countdownSeconds -= 1
    }
    
    @objc func loginClick()  {
        guard let phone = self.phoneTextField.text else {
            ProgressHUD.failed("请填写手机号")
            return
        }
        if phone.count == 0 {
            ProgressHUD.failed("请填写手机号")
            return
        }
        guard let number = self.numberTextField.text else {
            ProgressHUD.failed("请填写验证码")
            return
        }
        if number.count == 0 {
            ProgressHUD.failed("请填写验证码")
            return
        }
        if !isPrivacyAgreed {
            ProgressHUD.failed("请同意隐私协议")
            return
        }
    }
}

extension LoginVC: CLShanYanSDKManagerDelegate {
    func phoneNumberOneClickLogin() {
        CLShanYanSDKManager.setCLShanYanSDKManagerDelegate(self)
        let clUIConfigure = CLUIConfigure()
        clUIConfigure.viewController = self
 
        clUIConfigure.clBackgroundColor = UIColor("#F3F5FC")
        clUIConfigure.clAppPrivacyColor = [.clear, .clear]
        clUIConfigure.clPhoneNumberColor = UIColor("#1E1E1E")
        clUIConfigure.clNavigationBackgroundClear = NSNumber(booleanLiteral: true)
        clUIConfigure.clNavigationBottomLineHidden = NSNumber(booleanLiteral: true)
        clUIConfigure.clSloganTextHidden = NSNumber(booleanLiteral: true)
        clUIConfigure.clNavigationBackBtnHidden = NSNumber(booleanLiteral: true)
        clUIConfigure.clAppPrivacyColor = [UIColor.clear]
        
        clUIConfigure.clLoginBtnText = "手机号一键登录"
        clUIConfigure.clLoginBtnTextFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        clUIConfigure.clLoginBtnBgColor = UIColor("#4D96EB")
        clUIConfigure.clLoginBtnCornerRadius = NSNumber(floatLiteral: 7.0)
        clUIConfigure.clLoginBtnTextColor = UIColor.white
        
        clUIConfigure.clCheckBoxHidden = NSNumber(booleanLiteral: true)
        clUIConfigure.clCheckBoxValue = NSNumber(booleanLiteral: true)
        
        let LayOutConfigure = CLOrientationLayOut()
        LayOutConfigure.clAuthWindowOrientationOrigin = NSValue(cgPoint: .zero)
        LayOutConfigure.clAuthWindowOrientationWidth = NSNumber(floatLiteral: screenWidth)
        LayOutConfigure.clAuthWindowOrientationHeight = NSNumber(floatLiteral: screenHeight)
        
        LayOutConfigure.clLayoutPhoneLeft = NSNumber(floatLiteral: 25)
        LayOutConfigure.clLayoutPhoneWidth = NSNumber(floatLiteral: screenWidth - 25 * 2)
        LayOutConfigure.clLayoutPhoneHeight = NSNumber(floatLiteral: 55)
        LayOutConfigure.clLayoutPhoneTop = NSNumber(floatLiteral: 270)
        
        LayOutConfigure.clLayoutLoginBtnTop = NSNumber(floatLiteral: 440)
        LayOutConfigure.clLayoutLoginBtnLeft = NSNumber(floatLiteral: 25)
        LayOutConfigure.clLayoutLoginBtnRight = NSNumber(floatLiteral: -25)
        LayOutConfigure.clLayoutLoginBtnHeight = NSNumber(floatLiteral: 50)
        clUIConfigure.clOrientationLayOutPortrait = LayOutConfigure;
        clUIConfigure.customAreaView = { customView in
            
            let selectTypeView = LoginTypSelectView(type: .oneClickLogin, verifCodeClickBlock:  {
                CLShanYanSDKManager.finishAuthControllerCompletion()
            })
            customView.addSubview(selectTypeView)
            selectTypeView.snp.makeConstraints { make in
                make.right.left.equalToSuperview()
                make.top.equalToSuperview().offset(200)
            }
            
            
            let numberView = UIView()
            numberView.backgroundColor = UIColor("#F8FAFD")
            numberView.layer.cornerRadius = 10
            numberView.layer.masksToBounds = true
            customView.addSubview(numberView)
            numberView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(270)
                make.left.equalToSuperview().offset(25)
                make.right.equalToSuperview().offset(-25)
                make.height.equalTo(55)
            }
            customView.sendSubviewToBack(numberView)
            
            
            let view = UIView()
            view.addSubview(self.one_agreePrivacyAgreementButton)
            self.one_agreePrivacyAgreementButton.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.width.height.equalTo(16.auto())
                make.centerY.equalToSuperview()
            }
            let content_text = YYLabel()
            content_text.textColor = UIColor("#9D9D9D")
            content_text.font = .systemFont(ofSize: 12)
            let textStr = "同意《用户协议》和《隐私政策》"
            let range01 = (textStr as NSString).range(of: "《用户协议》", options: .caseInsensitive)
            let range02 = (textStr as NSString).range(of: "《隐私政策》", options: .caseInsensitive)
            let attriStr = NSMutableAttributedString(string: textStr)
            attriStr.yy_color = UIColor("#6E6E6E")
            attriStr.yy_font = .systemFont(ofSize: 14)
            attriStr.yy_setColor(UIColor("#5095EB"), range: range01)
            attriStr.yy_setColor(UIColor("#5095EB"), range: range02)
            let highlight01 = YYTextHighlight()
            highlight01.tapAction = {[weak self] _, _, _, _ in
                debugPrint("用户协议")
                CLShanYanSDKManager.finishAuthControllerCompletion()
                let vc = ProtocolPolicyVC()
                vc.urlStr = "https://bai.tongchengjianzhi.cn/ba/ab/yhxy.html"
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            let highlight02 = YYTextHighlight()
            highlight02.tapAction = {[weak self] _, _, _, _ in
                debugPrint("隐私政策")
                CLShanYanSDKManager.finishAuthControllerCompletion()
                let vc = ProtocolPolicyVC()
                vc.urlStr =  "https://bai.tongchengjianzhi.cn/ba/ab/yszc.html"
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            attriStr.yy_setTextHighlight(highlight01, range: range01)
            attriStr.yy_setTextHighlight(highlight02, range: range02)
            content_text.numberOfLines = 0
            content_text.attributedText = attriStr
            view.addSubview(content_text)
            content_text.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(self.one_agreePrivacyAgreementButton.snp.right).offset(6.auto())
                make.right.equalToSuperview()
            }
            customView.addSubview(view)
            view.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(25)
                make.top.equalToSuperview().offset(345)
                make.height.equalTo(17.auto())
            }
        }
        
        CLShanYanSDKManager.quickAuthLogin(with: clUIConfigure) { result in
            if (result.error != nil) {
                debugPrint("error: \(result.error!)")
            } else {
                if let vc = topViewController() {
                    for view in vc.view.subviews {
                        if let btn = view as? UIButton, btn.titleLabel?.text == "手机号一键登录"  {
                            btn.removeTarget(nil, action: nil, for: .allEvents)
                            btn.addTarget(self, action: #selector(self.oneLoginClick), for: .touchUpInside)
                        }
                    }
                }
            }
        } oneKeyLoginListener: { result in
            debugPrint("result = \(result)")
        }
    }
    
    @objc func oneLoginClick() {
        if !isPrivacyAgreed {
            ProgressHUD.failed("请同意隐私协议")
            return
        }
        CLShanYanSDKManager.loginBtnClick()
    }
}

enum LoginType {
    case oneClickLogin
    case verifCodeLogin
}

class LoginTypSelectView: UIView {
    let type: LoginType
    lazy var oneClickButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitle("手机号一键登录", for: .normal)
        button.setTitleColor(UIColor("#3D3D3D"), for: .normal)
        button.setTitleColor(UIColor("#1F1F1F"), for: .selected)
        button.addTarget(self, action: #selector(oneClickButtonClick), for: .touchUpInside)
        return button
    }()
    lazy var verifCodeButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitle("验证码登录", for: .normal)
        button.setTitleColor(UIColor("#3D3D3D"), for: .normal)
        button.setTitleColor(UIColor("#1F1F1F"), for: .selected)
        button.addTarget(self, action: #selector(verifCodeButtonClick), for: .touchUpInside)
        return button
    }()
    lazy var lin: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor("#6FA5F6")
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    var oneClickBlock: (() -> ())? = nil
    var verifCodeClickBlock: (() -> ())? = nil
    
    init(type: LoginType,
         oneClickBlock: (() -> ())? = nil,
         verifCodeClickBlock: (() -> ())? = nil) {
        self.type = type
        self.oneClickBlock = oneClickBlock
        self.verifCodeClickBlock = verifCodeClickBlock
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 22.auto()))
        initializeUIInfo()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeUIInfo() {
        self.addSubview(lin)
        self.addSubview(self.oneClickButton)
        self.addSubview(self.verifCodeButton)
        self.oneClickButton.isSelected = type == .oneClickLogin
        self.verifCodeButton.isSelected = type == .verifCodeLogin
        oneClickButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26.auto())
            make.top.equalToSuperview()
            make.height.equalTo(17.auto())
        }
        verifCodeButton.snp.makeConstraints { make in
            make.left.equalTo(oneClickButton.snp.right).offset(31.auto())
            make.top.equalToSuperview()
            make.height.equalTo(17.auto())
        }
        lin.snp.makeConstraints { make in
            make.width.equalTo(70.auto())
            make.height.equalTo(10.auto())
            make.centerX.equalTo(type == .oneClickLogin ? oneClickButton.snp.centerX:verifCodeButton.snp.centerX)
            make.bottom.equalTo(verifCodeButton.snp.bottom).offset(3.auto())
            make.bottom.equalToSuperview()
        }
    }
    
    
    @objc func oneClickButtonClick() {
        self.oneClickBlock?()
    }
    
    @objc func verifCodeButtonClick() {
        self.verifCodeClickBlock?()
    }
}
