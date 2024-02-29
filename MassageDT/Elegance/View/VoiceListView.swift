//
//  VoiceListView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/20.
//

import SwiftUI
import SDWebImageSwiftUI
import ExytePopupView
import ProgressHUD

struct VoiceListView: View {
    @Binding var dataSource: [ElegantModel]
    var voiceClickBlock: ((ElegantModel) -> Void)?
    var body: some View {
        ScrollView {
            LazyVStack(content: {
                ForEach(dataSource.indices, id: \.self) { index in
                    EleganceItemView(itemModel: dataSource[index], addBlick: {
                        dataSource.remove(at: index)
                    }).onTapGesture {
                            voiceClickBlock?(dataSource[index])
                        }
                }
            })
            .padding(.top, 12)
        }
        .background(content: {
            Color("#FAFAFA")
        })
    }
}

/// 语音Item
struct EleganceItemView: View {
    let itemModel: ElegantModel
    let addBlick: (() -> ())?
    @State var isMore = false
    var body: some View {
        HStack {
            WebImage(url: URL(string: itemModel.userAvatar))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(40)
            VStack(alignment: .leading, spacing: 0) {
                HStack(content: {
                    Text(itemModel.nickname)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.bottom, 14)
                    Spacer()
                    Text(itemModel.cityName)
                        .foregroundStyle(Color("#3C3C3C"))
                        .font(.system(size: 14))
                })
                HStack(spacing: 10) {
                    ForEach(itemModel.userTags.indices, id:\.self) { index in
                        Text(itemModel.userTags[index])
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color("#4E96EB"))
                    }
                }
                .padding(.bottom, 14)
                HStack {
                    Button {
                        if let url = URL(string: itemModel.audioSrc) {
                            if SystemCaching.full.count > 0 {
                                KeyWindowPopView.showPop {
                                    BaseTabBarControllerView.tab.selectedIndex = 1
                                }
                            } else {
                                AudioManager.shared.playAudio(from: url)
                            }
                        }
                    } label: {
                        ZStack(alignment: .trailing) {
                            Image("yuyin")
                            Text("")
                                .foregroundStyle(.white)
                                .padding(.trailing, 20)
                        }
                    }
                    Spacer()
                    Button(action: {
                        isMore = true
                    }, label: {
                        Image("more")
                    })
                }
                Spacer()
            }
                Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .frame(height: 110)
        .background {
            Color.white
        }
        .popup(isPresented: $isMore) {
            MoreView(isMore: $isMore) { value in
                NetWork.blackRequest(msg: value) { val in
                    if val {
                        var set = Set(SystemCaching.blackList)
                        set.insert(self.itemModel.id)
                        SystemCaching.blackList = Array(set)
                        ProgressHUD.succeed("拉黑成功")
                        
                        var followset = Set(SystemCaching.followList)
                        followset.remove(self.itemModel.id)
                        SystemCaching.followList = Array(followset)
                        self.addBlick?()
                        RootViewToggle.default.updateEleganceData()
                    }
                }
            } reportBlock: { value in
                NetWork.blackRequest(msg: value) { val in
                    if val {
                        ProgressHUD.succeed("举报成功")
                    }
                }
            }
        } customize: {
            $0
                .isOpaque(true)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        }
    }
}



#Preview {
    VoiceListView(dataSource: .constant([]))
}
