//
//  SetView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/22.
//

import SwiftUI
import ExytePopupView

struct SetView: View {
    @State var isNickName = false
    @State var iconImage: UIImage?
    @State var pickerManager: ImagePickerManager?
    @State var isLogOff = false
    @State var isLogOut = false
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 0) {
                Button {
                    pickerManager?.presentImagePicker()
                } label: {
                    HStack(spacing: 9) {
                        Text("头像")
                            .font(.system(size: 15))
                            .foregroundStyle(Color("#333333"))
                        Spacer()

                        if let img = self.iconImage {
                            Image(uiImage: img)
                                .resizable()
                                .frame(width: 23, height: 23)
                                .clipShape(Circle())
                        } else {
                            Image("my_select")
                                .resizable()
                                .frame(width: 23, height: 23)
                                .clipShape(Circle())
                        }

                        Image("right_icon")
                            .resizable()
                            .frame(width: 5, height: 10)
                    }
                    .frame(maxWidth: screenWidth)
                    .frame(height: 60)
                    .padding(.horizontal, 16)
                }
        
                VStack {}
                    .frame(maxWidth: screenWidth)
                    .frame(height: 0.5)
                    .background(Color("#FAFAFA"))
                    .padding(.horizontal, 15)
                
                Button {
                    isNickName = true
                } label: {
                    HStack(spacing: 9) {
                        Text("昵称")
                            .font(.system(size: 15))
                            .foregroundStyle(Color("#333333"))
                        Spacer()
                        
                        Text("霹雳小子")
                        Image("right_icon")
                            .resizable()
                            .frame(width: 5, height: 10)
                    }
                    .frame(maxWidth: screenWidth)
                    .frame(height: 60)
                    .padding(.horizontal, 16)
                }

            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            .padding(.horizontal, 15)
            
            VStack(spacing: 0) {
                Button {
                    isLogOff = true
                } label: {
                    HStack(spacing: 9) {
                        Text("注销账号")
                            .font(.system(size: 15))
                            .foregroundStyle(Color("#333333"))
                        Spacer()
                        
                        Image("right_icon")
                            .resizable()
                            .frame(width: 5, height: 10)
                    }
                    .frame(maxWidth: screenWidth)
                    .frame(height: 60)
                    .padding(.horizontal, 16)
                }

                
                VStack {}
                    .frame(maxWidth: screenWidth)
                    .frame(height: 0.5)
                    .background(Color("#FAFAFA"))
                    .padding(.horizontal, 15)

                Button {
                    isLogOut = true
                } label: {
                    HStack(spacing: 9) {
                        Text("退出登录")
                            .font(.system(size: 15))
                            .foregroundStyle(Color("#333333"))
                        Spacer()
                        
                        Image("right_icon")
                            .resizable()
                            .frame(width: 5, height: 10)
                    }
                    .frame(maxWidth: screenWidth)
                    .frame(height: 60)
                    .padding(.horizontal, 16)
                }

            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            .padding(.horizontal, 15)
            Spacer()
        }
        .padding(.top, 12)
        .frame(maxWidth: screenWidth, maxHeight: screenHeight)
        .background {
            Color("#FAFAFA")
        }
        .onAppear(perform: {
            pickerManager = ImagePickerManager.showImageSelect { image in
                self.iconImage = image
            }
        })
        .popup(isPresented: $isNickName) {
           ChangeNicknameView(isNickName: $isNickName)
        } customize: {
            $0
                .isOpaque(true)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        }
        .popup(isPresented: $isLogOff, view: {
            LogOffView(isLogOff: $isLogOff, msg: "注销账号会删除所有数据， 确认注销吗？")
        }, customize: {
            $0.isOpaque(true)
            .closeOnTap(false)
            .backgroundColor(.black.opacity(0.4))
        })
        .popup(isPresented: $isLogOut, view: {
            LogOutView(isLogOff: $isLogOut, msg: "您确定要退出登录吗？")
        }, customize: {
            $0.isOpaque(true)
            .closeOnTap(false)
            .backgroundColor(.black.opacity(0.4))
        })
    }
}



#Preview {
    SetView()
}


struct ChangeNicknameView: View {
    @State var nickName: String = ""
    @Binding var isNickName: Bool
    var body: some View {
        VStack(spacing: 0) {
            Text("修改昵称")
                .padding(.bottom, 12)
            
            TextField("请输入昵称", text: $nickName)
                .padding(.horizontal, 17)
                .padding(.vertical, 15)
                .border(Color("#5A5A5A"), width: 0.5)
                .padding(.horizontal, 17)
                  
             
            Button {
                isNickName = false
            } label: {
                Text("保存")
                    .padding(.horizontal, 98)
                    .padding(.vertical, 14)
                    .foregroundColor(.white)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color("#77AEF7"), Color("#4D96EB")]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(10)
            }
            .padding(.top, 29)
        }
        .padding(.vertical, 25)
        .frame(maxWidth: screenWidth)
        .background {
            Color.white
        }
        .cornerRadius(9)
        .padding(.horizontal, 25)
        .shadow(color: Color("#4D96EB"), radius: 5)
       
    }
}
