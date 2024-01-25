//
//  VideoView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/21.
//

import UIKit
import SJVideoPlayer

class VideoView: UIView {
    lazy var player: SJVideoPlayer = {
        let player = SJVideoPlayer()
        return player
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initWithUI() {
        self.addSubview(self.player.view)
        player.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
