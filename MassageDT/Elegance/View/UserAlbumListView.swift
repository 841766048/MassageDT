//
//  UserAlbumListView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/23.
//

import SwiftUI

struct UserAlbumListView: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), content: {
                ForEach(0..<100, id: \.self) { indx in
                    Image("jjp")
                        .resizable()
                        .frame(width: 110 ,height: 121)
                        .clipped()
                }
            })
        }
    }
}

#Preview {
    UserAlbumListView()
}
