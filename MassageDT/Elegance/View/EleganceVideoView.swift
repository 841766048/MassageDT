//
//  EleganceVideoView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/20.
//

import SwiftUI
import ExytePopupView

/// 视频Item
struct EleganceVideoView: View {
    var videoClickBlock: ((EleganceModel) -> Void)?
    init(videoClickBlock: ( (EleganceModel) -> Void)? = nil) {
        self.videoClickBlock = videoClickBlock
    }
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), content: {
                ForEach(0...30, id: \.self) { index in
                    EleganceVideoItemView()
                        .onTapGesture {
                            videoClickBlock?(EleganceModel())
                        }
                }
            })
            .padding(.horizontal, 15)
        }
    }
}

struct EleganceVideoItemView: View {
    @State var isMore = false
    var body: some View {
        VStack(spacing: 0, content: {
            Image("01")
                .resizable()
                .frame(height: 180)
                .clipped()
                .padding(.bottom, 5)
            
            HStack(spacing: 0, content: {
                Image("01")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
                    .clipped()
                    .padding(.trailing, 5)
                VStack {
                    HStack(content: {
                        Text("Placeholder")
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
                        Text("声音甜美")
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
                print("拉黑原因:\(value)")
            } reportBlock: { value in
                print("举报原因:\(value)")
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
    EleganceVideoView()
}
