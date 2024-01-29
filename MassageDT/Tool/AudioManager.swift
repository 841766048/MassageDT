//
//  AudioManager.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/26.
//

import Foundation
import AVFoundation

class AudioManager {
    static let shared = AudioManager()

    private var player: AVPlayer?

    private init() {
        // 私有初始化，确保只能从内部创建实例
    }

    func playAudio(from url: URL) {
        // 停止当前播放
        stopAudio()
        // 创建 AVPlayer 实例
        player = AVPlayer(url: url)

        // 播放音频
        player?.play()
    }

    func stopAudio() {
        // 停止当前播放
        player?.pause()
        player = nil
    }
}
