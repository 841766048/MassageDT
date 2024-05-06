//
//  ReservationServiceSuccessView.swift
//  MassageDT
//  
//  Created by wealon on 2024.
//  MassageDT.
//  
    

import SwiftUI
import SDWebImageSwiftUI
class ReservationServiceSuccessViewModel: ObservableObject {
    var okClick:(() -> ())?
    @Published var itemModel: ElegantModel = ElegantModel()
}


struct ReservationServiceSuccessView: View {
    let viewModel: ReservationServiceSuccessViewModel
    var body: some View {
        VStack {
            Text("预约成功！")
                .font(.system(size: 16))
                .foregroundColor(Color("#4E96EB"))
                .padding(.bottom, 34)
            VStack(content: {
                WebImage(url: URL(string: "https://p6.itc.cn/images01/20230919/53955b555dad4a2497cb8ededaaeb36f.jpeg"))
                    .placeholder(Image("图片缺失"))
                    .resizable()
                    .frame(width: 110 ,height: 121)
                    .cornerRadius(3)
                    .clipped()
                
                Text("服务名字")
                    .font(.system(size: 13))
                    .foregroundColor(Color(UIColor("#3C3C3C")))
                    .padding(.top, 7)
                    .padding(.bottom, 7)
                
                Text("198元")
                    .font(.system(size: 13))
                    .foregroundStyle(Color("#FF0000"))
                
            })
            .frame(width: 110)
            .overlay {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color("#4E96EB"), lineWidth: 1.5)
            }
            
            Spacer()
            Button {
                viewModel.okClick?()
            } label: {
                Text("好的")
                    .padding(.horizontal, 48)
                    .padding(.vertical, 8)
                    .foregroundColor(.white)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color("#77AEF7"), Color("#4D96EB")]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(14)
            }
            .padding(.bottom, 29)
            
        }
    }
}

//#Preview {
//    ReservationServiceSuccessView()
//}
