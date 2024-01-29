//
//  FollowView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/21.
//

import SwiftUI

struct FollowView: View {
    @State var dataSource: [ElegantModel] = []
    var body: some View {
        VStack {
            if dataSource.count == 0 {
                VStack(spacing: 20) {
                    Image("nofollow")
                    Text("暂无关注用户哦")
                        .font(.system(size: 18))
                        .foregroundStyle(Color("#3C3C3C"))
                }
                .padding(.top, 62)
                .frame(maxHeight: screenHeight, alignment: .top)
                .background(content: {
                    Color.clear
                })
            } else {
                VoiceListView(dataSource: $dataSource)
            }
        }
        .background(content: {
            Color.clear
        }).onAppear {
            self.dataSource = UserFollowBlacklist.default.followList
        }
    }
}

#Preview {
    FollowView()
}
