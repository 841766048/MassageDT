//
//  ReservationServiceView.swift
//  MassageDT
//  
//  Created by wealon on 2024.
//  MassageDT.
//  
    

import SwiftUI
import ProgressHUD
import SDWebImageSwiftUI

class ReservationServiceViewModel: ObservableObject {
    var payClick:(() -> ())?
    @Published var itemModel: ElegantModel = ElegantModel()
}

struct ReservationServiceView: View {
    @State var serverClickIndex = -1
    @State var payClickIndex = 0
    let viewModel: ReservationServiceViewModel
    var body: some View {
        VStack {
            ScrollView {
                HStack(content: {
                    Text("选择服务项目")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color("#1E1E1E"))
                    Spacer()
                })
                .padding(.horizontal, 15)
                .padding(.top, 10)
                
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), content: {
                    ForEach(0..<viewModel.itemModel.services.count, id: \.self) { indx in
                        let itemModel = viewModel.itemModel.services[indx]
                        VStack(content: {
                            WebImage(url: URL(string: itemModel.serviceIcon ?? "") )
                                .placeholder(Image("图片缺失"))
                                .resizable()
                                .frame(width: 110 ,height: 121)
                                .cornerRadius(3)
                                .clipped()
                            
                            Text(itemModel.serviceName ?? "")
                                .font(.system(size: 13))
                                .foregroundColor(Color(UIColor("#3C3C3C")))
                                .padding(.top, 7)
                                .padding(.bottom, 7)
                            
                            Text("\(Int(itemModel.servicePrice ?? 0.0))元")
                                .font(.system(size: 13))
                                .foregroundStyle(Color("#FF0000"))
                                .padding(.bottom, 7)
                            
                        })
                        .frame(width: 110)
                        .overlay {
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(serverClickIndex != indx ? Color.white:Color("#4E96EB"), lineWidth: 1.5)
                        }
                        .shadow(color: Color("#4D96EB").opacity(0.3),radius: 5)
                        .onTapGesture {
                            serverClickIndex = indx
                        }
                    }
                })
                .padding(.bottom, 18)
                
                HStack(content: {
                    Text("选择支付方式")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color("#1E1E1E"))
                    Spacer()
                })
                .padding(.horizontal, 15)
                .padding(.top, 10)
                
                HStack(spacing: 20) {
                    ForEach(0..<glaModel!.pconfs.count, id: \.self) { index in
                        let model = glaModel!.pconfs[index]
                        if model.type == "1" {
                            Text("支付宝")
                                .padding(.horizontal, 37)
                                .padding(.vertical, 6)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(payClickIndex != 1 ? Color.white:Color("#4E96EB"), lineWidth: 1.5)
                                }
                                .shadow(color:
                                            Color("#4D96EB").opacity(payClickIndex != 1 ? 0.3:0)
                                        ,radius: 10)
                                .onTapGesture {
                                    payClickIndex = 1
                                }
                        } else if model.type == "2" {
                            Text("微信")
                                .padding(.horizontal, 37)
                                .padding(.vertical, 6)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(payClickIndex != 0 ? Color.white:Color("#4E96EB"), lineWidth: 1.5)
                                }
                                .shadow(color: Color("#4D96EB").opacity(payClickIndex != 0 ? 0.3:0),radius: 10)
                                .onTapGesture {
                                    payClickIndex = 0
                                }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 20)
            
            Button {
                if serverClickIndex >= 0 {
//                    viewModel.payClick?()
                    let itemModel = viewModel.itemModel.services[serverClickIndex]
                    if payClickIndex == 0 {
                        NetWork.wxPayInfo(viewModel.itemModel.id, cate_id: "\(itemModel.id ?? 0)", price: "\(Int(itemModel.servicePrice ?? 0))")
                    } else if payClickIndex == 1 {
                        NetWork.aliPayInfo(viewModel.itemModel.id, cate_id: "\(itemModel.id ?? 0)", price: "\(Int(itemModel.servicePrice ?? 0))")
                    }
                } else {
                    ProgressHUD.error("选择一个服务")
                }
            } label: {
                Text("立即支付")
                    .padding(.horizontal, 98)
                    .padding(.vertical, 14)
                    .foregroundColor(.white)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color("#77AEF7"), Color("#4D96EB")]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(28)
            }
            .padding(.bottom, 29)
        }
    }
}
