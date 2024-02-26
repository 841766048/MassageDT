//
//  EleganceView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/20.
//

import SwiftUI

class EleganceViewModel: ObservableObject {
    @Published var isLocate = false
    /// 更多点击
    var moreClickBlock: ((ElegantModel) -> Void)?
    /// 语音点击
    var voiceClickBlock: ((ElegantModel) -> Void)?
    /// 视频点击
    var videoClickBlock: ((ElegantModel) -> Void)?
    /// 我的关注
    var followClickBlock: (() -> Void)?
    // 音频
    @Published var audio: [ElegantModel] = []
    // 视频
    @Published var video: [ElegantModel] = []
}


struct EleganceView: View {
    let type: [String] = ["语音", "视频"]
    @State private var selectedIndex: Int = 0
    
    @State var isLocate = false
    @ObservedObject var viewModel: EleganceViewModel
    init(viewModel: EleganceViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        VStack {
            if !viewModel.isLocate {
                LocateTipsView()
                    .padding(.bottom, 12)
            }
            TypeView(selectedIndex: $selectedIndex, followClickBlock: {
                viewModel.followClickBlock?()
            })
            TabView(selection: $selectedIndex,
                    content:  {
                VoiceListView(dataSource: $viewModel.audio, voiceClickBlock: { model in
                    viewModel.voiceClickBlock?(model)
                })
                    .tag(0)
                EleganceVideoView(videos: $viewModel.video, videoClickBlock: { model in
                    viewModel.videoClickBlock?(model)
                }).tag(1)
            })
            .background(content: {
                Color.red
            })
            .onAppear(perform: {
                UITabBar.appearance().isHidden = true
            })
        }
        .padding(.top, 12)
        .background {
            Color("#FAFAFA")
        }
    }
    
    func createBottomLine(_ proxy: GeometryProxy, preferences: [MySegementPreferenceData]) -> some View {
        let p = preferences.first(where: { $0.viewIdx == self.selectedIndex })
        
        let bounds = proxy[p!.bounds]
        
        return RoundedRectangle(cornerRadius: 3.5)
            .foregroundColor(Color("#6FA5F6"))
            .frame(width: bounds.width, height: 7)
            .offset(x: bounds.minX, y: bounds.height - 7)
    }
}


struct LocateTipsView: View {
    var body: some View {
        HStack {
            Text("开启定位享受语视按摩")
            Spacer()
            Button(action: {
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }, label: {
                Text("开启")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color("#4E96EB"))
            })
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 14)
        .overlay(content: {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("#4E96EB"), lineWidth: 1)
                .shadow(color: .black, radius: 10, x: 10, y: 10)
        })
        .padding(.horizontal, 15)
    }
}

#Preview {
    EleganceView(viewModel: EleganceViewModel())
}
