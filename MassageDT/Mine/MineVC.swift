//
//  MineVC.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/20.
//

import UIKit

class MineVC: BaseViewController {
    lazy var headImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "默认头像")
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    lazy var nickName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor("#1E1E1E")
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    lazy var orderView: FuncView = {
        let view = FuncView()
        view.iconImage.image = UIImage(named: "order")
        view.titleLabel.text = "订单"
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor("#4E96EB").cgColor
        view.layer.masksToBounds = true
        view.buttonBlock = {
            let vc = MineWebVC()
            vc.urlString = glaModel?.my_need_url
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return view
    }()
    
    lazy var walletView: FuncView = {
        let view = FuncView()
        view.iconImage.image = UIImage(named: "wallet")
        view.titleLabel.text = "钱包"
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor("#EBA34E").cgColor
        view.layer.masksToBounds = true
        view.buttonBlock = {
            let vc = MineWebVC()
            vc.urlString = glaModel?.my_account
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return view
    }()
    
    lazy var tabeViewHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.frame = CGRect(x: 15, y: 0, width: screenWidth - 15*2, height: 220)
        view.addSubview(headImageView)
        view.addSubview(nickName)
        view.addSubview(orderView)
        view.addSubview(walletView)
        headImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        nickName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(headImageView.snp.right).offset(15)
        }
        orderView.snp.makeConstraints { make in
            make.left.equalTo(headImageView.snp.left)
            make.top.equalTo(headImageView.snp.bottom).offset(18)
            make.right.equalTo(view.snp.centerX).offset(-14)
            make.height.equalTo(47)
        }
        walletView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(headImageView.snp.bottom).offset(18)
            make.left.equalTo(view.snp.centerX).offset(14)
            make.height.equalTo(47)
        }
        return view
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableHeaderView = self.tabeViewHeaderView
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()
    var dataSource = ["我的关注", "官方客服", "操作帮助", "用户协议", "隐私政策", "设置"]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的"
        view.backgroundColor = UIColor("#FAFAFA")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nickName.text = getNickName()
        if let img = AvatarManager.loadAvatar(forAccount: SystemCaching.phone) {
            self.headImageView.image = img
        }
        
    }
    override func initializeUIInfo() {
        super.initializeUIInfo()
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
    }
}

extension MineVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 15)
        cell.textLabel?.textColor = UIColor("#333333")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .white
        cell.backgroundColor = .white
        
        //圆角半径
        let cornerRadius:CGFloat = 15.0
        
        //下面为设置圆角操作（通过遮罩实现）
        let sectionCount = tableView.numberOfRows(inSection: indexPath.section)
        let shapeLayer = CAShapeLayer()
        cell.layer.mask = nil
        //如果是最后一个单元格则设置圆角遮罩
        var bounds = cell.bounds
       
        if indexPath.row == sectionCount - 1 {
            bounds.size.height -= 1.0  //这样每一组尾行底部分割线不显示
            let bezierPath = UIBezierPath(roundedRect: bounds,
                                          byRoundingCorners: [.bottomLeft,.bottomRight],
                                          cornerRadii: CGSize(width: cornerRadius,height: cornerRadius))
            shapeLayer.path = bezierPath.cgPath
            cell.layer.mask = shapeLayer
        } else if indexPath.row == 0 {
            bounds.size.height -= 1.0  //这样每一组尾行底部分割线不显示
            let bezierPath = UIBezierPath(roundedRect: bounds,
                                          byRoundingCorners: [.topLeft,.topRight],
                                          cornerRadii: CGSize(width: cornerRadius,height: cornerRadius))
            shapeLayer.path = bezierPath.cgPath
            cell.layer.mask = shapeLayer
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataSource[indexPath.row] {
        case "我的关注":
            self.navigationController?.pushViewController(FollowVC(), animated: true)
        case "官方客服":
            self.navigationController?.pushViewController(KeFuVC(), animated: true)
        case "操作帮助":
            let vc = ProtocolPolicyVC()
            vc.title = "操作帮助"
            vc.urlStr = "https://dtpubs.51quanmo.cn/AB/Operation.Help.html"
            self.navigationController?.pushViewController(vc, animated: true)
        case "用户协议":
            let vc = ProtocolPolicyVC()
            vc.title = "用户协议"
            vc.urlStr = "https://dtpubs.51quanmo.cn/AB/User.Agreement.html"
            self.navigationController?.pushViewController(vc, animated: true)
        case "隐私政策":
            let vc = ProtocolPolicyVC()
            vc.title = "隐私政策"
            vc.urlStr =  "https://dtpubs.51quanmo.cn/AB/Privacy.Policy.html"
            self.navigationController?.pushViewController(vc, animated: true)
        case "设置":
            navigationController?.pushViewController(SetVC(), animated: true)
        default:
            break
        }
    }
}

class FuncView: UIView {
    lazy var iconImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    lazy var button: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        but.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return but
    }()
    var buttonBlock: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initWithUI() {
        self.addSubview(iconImage)
        self.addSubview(titleLabel)
        self.addSubview(button)
        
        iconImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.snp.centerX).offset(-7)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.snp.centerX).offset(7)
            make.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func buttonClick() {
        self.buttonBlock?()
    }
}
