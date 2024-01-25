//
//  VideoViewVC.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/21.
//

import UIKit
import SJVideoPlayer

class VideoViewVC: BaseViewController {
    lazy var player: SJVideoPlayer = {
        let player = SJVideoPlayer()
        player.gestureController.supportedGestureTypes = .singleTap
        player.playbackObserver.playbackDidFinishExeBlock = { _ in
            player.replay()
        }
        player.gestureController.singleTapHandler = { _, _ in
            player.isPaused ? player.play():player.pauseForUser()
        }
        player.defaultEdgeControlLayer.topAdapter.removeItem(forTag: SJEdgeControlLayerTopItem_Back)
        player.defaultEdgeControlLayer.topAdapter.removeItem(forTag: SJEdgeControlLayerBottomItem_Full)
        player.defaultEdgeControlLayer.topAdapter.removeItem(forTag: SJEdgeControlLayerBottomItem_Progress)
        player.defaultEdgeControlLayer.topAdapter.removeItem(forTag: SJEdgeControlLayerBottomItem_Definition)
        player.defaultEdgeControlLayer.topAdapter.removeItem(forTag: SJEdgeControlLayerBottomItem_CurrentTime)
        player.defaultEdgeControlLayer.topAdapter.removeItem(forTag: SJEdgeControlLayerBottomItem_DurationTime)
        player.defaultEdgeControlLayer.topAdapter.removeItem(forTag: SJEdgeControlLayerBottomItem_Separator)
        player.defaultEdgeControlLayer.automaticallyShowsPictureInPictureItem = false
        player.defaultEdgeControlLayer.showsMoreItem = false
        player.defaultEdgeControlLayer.isHiddenBottomProgressIndicator = true
        player.rotationManager?.isDisabledAutorotation = true
        player.isPausedInBackground = true
        player.resumePlaybackWhenAppDidEnterForeground = false
        
        return player
    }()
    
    lazy var infoContentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    lazy var headeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "丽娜"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor("#1E1E1E")
        return label
    }()
    
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.text = "声音甜美    温柔"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor("#4E96EB")
        return label
    }()
    
    let rightIcon: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "right_icon"))
        return imageV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "风采"
        if let url = URL(string: "https://crazynote.v.netease.com/2019/0811/6bc0a084ee8655bfb2fa31757a0570f4qt.mp4") {
            let asset = SJVideoPlayerURLAsset.init(url: url)
            player.urlAsset = asset
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.vc_viewDidAppear()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.vc_viewWillDisappear()
    }
    override func initializeUIInfo() {
        super.initializeUIInfo()
        view.addSubview(player.view)
        player.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(self.infoContentView)
        infoContentView.addSubview(headeImageView)
        infoContentView.addSubview(nameLabel)
        infoContentView.addSubview(typeLabel)
        infoContentView.addSubview(rightIcon)
        
        infoContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
            make.bottom.equalToSuperview().offset(-61)
            make.height.equalTo(92)
        }
        infoContentView.backgroundColor = .white
        infoContentView.layer.cornerRadius = 10
        infoContentView.layer.borderWidth = 1
        infoContentView.layer.borderColor = UIColor("#4E96EB").cgColor
        
        
        headeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(60)
        }
        
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.left.equalTo(headeImageView.snp.right).offset(10)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-22)
            make.left.equalTo(headeImageView.snp.right).offset(10)
        }
        
        rightIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        infoContentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.vc_viewDidDisappear()
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    @objc func buttonClick() {
        print("跳转详情")
        self.navigationController?.pushViewController(UserDetailsVC(), animated: true)
    }
}
