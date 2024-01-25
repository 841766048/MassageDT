//
//  VoiceListView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/20.
//

import SwiftUI
import ExytePopupView

struct VoiceListView: View {
    @Binding var dataSource: [EleganceModel]
    var voiceClickBlock: ((EleganceModel) -> Void)?
    var body: some View {
        ScrollView {
            LazyVStack(content: {
                ForEach(dataSource, id: \.id) { model in
                    EleganceItemView(itemModel: model)
                        .onTapGesture {
                            voiceClickBlock?(model)
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
    let itemModel: EleganceModel
    @State var isMore = false
    var body: some View {
        HStack {
            Image(itemModel.iconImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(40)
            VStack(alignment: .leading, spacing: 0) {
                HStack(content: {
                    Text(itemModel.name)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.bottom, 14)
                    Spacer()
                    Text(itemModel.address)
                        .foregroundStyle(Color("#3C3C3C"))
                        .font(.system(size: 14))
                })
                HStack(spacing: 10) {
                    ForEach(itemModel.feature.indices, id:\.self) { index in
                        Text(itemModel.feature[index])
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color("#4E96EB"))
                    }
                }
                .padding(.bottom, 14)
                HStack {
                    ZStack(alignment: .trailing) {
                        Image("yuyin")
                        Text(itemModel.voiceSeconds)
                            .foregroundStyle(.white)
                            .padding(.trailing, 20)
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
    VoiceListView(dataSource: .constant([]))
}
