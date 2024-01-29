//
//  UserAlbumListView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserAlbumListView: View {
    let iteModel: ElegantModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), content: {
                ForEach(0..<iteModel.userAlbums.count, id: \.self) { indx in
                    WebImage(url: URL(string: iteModel.userAlbums[indx]))
                        .placeholder(Image("图片缺失"))
                        .resizable()
                        .frame(width: 110 ,height: 121)
                        .clipped()
                }
            })
        }
    }
}
