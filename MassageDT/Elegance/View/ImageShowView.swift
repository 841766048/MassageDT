//
//  ImageShowView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageShowView: View {
    @Binding var imgaeURL: String
    var body: some View {
        VStack {
            WebImage(url: URL(string: imgaeURL))
                .placeholder(Image("图片缺失"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: screenWidth - 30)
                .clipped()
        }
    }
}

#Preview {
    ImageShowView(imgaeURL: .constant(""))
}
