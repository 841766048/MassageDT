//
//  EleganceVideoView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/20.
//

import SwiftUI
import ExytePopupView
import SDWebImageSwiftUI  
import ProgressHUD

/// 视频Item
struct EleganceVideoView: View {
    @Binding var videos: [ElegantModel]
    var videoClickBlock: ((ElegantModel) -> Void)?
    init(videos: Binding<[ElegantModel]>, videoClickBlock: ( (ElegantModel) -> Void)? = nil) {
        _videos = videos
        self.videoClickBlock = videoClickBlock
    }
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), content: {
                ForEach(videos.indices, id: \.self) { index in
                    EleganceVideoItemView(item: videos[index])
                        .onTapGesture {
                            videoClickBlock?(videos[index])
                        }
                }
            })
            .padding(.horizontal, 15)
        }
    }
}

struct EleganceVideoItemView: View {
    @State var isMore = false
    let item: ElegantModel
    var body: some View {
        VStack(spacing: 0, content: {
            WebImage(url: URL(string: item.userAvatar))
                .resizable()
                .frame(height: 180)
                .clipped()
                .padding(.bottom, 5)
            
            HStack(spacing: 0, content: {
                WebImage(url: URL(string: item.userAvatar))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
                    .clipped()
                    .padding(.trailing, 5)
                VStack {
                    HStack(content: {
                        Text(item.nickname)
                            .font(.system(size: 14))
                            .foregroundStyle(Color("#1E1E1E"))
                        Spacer()
                        Button(action: {
                            isMore = true
                        }, label: {
                            Image("more")
                                .frame(width: 14, height: 3)
                        })
                    })
                    
                    HStack(spacing: 5, content: {
                        Text(item.userTags.joined(separator: " "))
                            .lineLimit(1)
                            .font(.system(size: 13))
                            .foregroundStyle(Color("#4E96EB"))
                        Spacer()
                    })
                    Spacer()
                }
                Spacer()
            })
            .padding(.horizontal, 5)
        })
        .padding(.bottom, 15)
        .popup(isPresented: $isMore) {
            MoreView(isMore: $isMore) { value in
                NetWork.blackRequest(msg: value) { val in
                    if val {
                        var set = Set(SystemCaching.blackList)
                        set.insert(item.id)
                        SystemCaching.blackList = Array(set)
                        ProgressHUD.succeed("拉黑成功")
                        
                        var followset = Set(SystemCaching.followList)
                        followset.remove(item.id)
                        SystemCaching.followList = Array(followset)
                        
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
    EleganceVideoView(videos: .constant([]))
}
