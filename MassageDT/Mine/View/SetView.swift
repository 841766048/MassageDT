//
//  SetView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/22.
//

import SwiftUI
import SwiftSoup
import ExytePopupView

struct SetView: View {
    @State var isNickName = false
    @State var nickName: String = ""
    @State var iconImage: UIImage?
    @State var pickerManager: ImagePickerManager?
    @State var isLogOff = false
    @State var isLogOut = false
    @State var logoutTip = "注销账号会删除所有数据， 确认注销吗？"
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
                            Image("默认头像")
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
                        
                        Text(nickName)
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
                    NetWork.performAccountLogoutText { tips in
                        if tips.count > 0 {
                            do {
                               let doc: Document = try SwiftSoup.parse(tips)
                                logoutTip = try doc.text()
                                isLogOff = true
                            } catch Exception.Error(let type, let message) {
                                print(message)
                            } catch {
                                print("error")
                            }
                           
                        }
                    }
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
            nickName = getNickName()
            self.iconImage = AvatarManager.loadAvatar(forAccount: SystemCaching.phone)
            pickerManager = ImagePickerManager.showImageSelect { image in
                if let img = image {
                    self.iconImage = image
                    AvatarManager.saveAvatar(image: img, forAccount: SystemCaching.phone)
                }
            }
        })
        .popup(isPresented: $isNickName) {
            ChangeNicknameView(nickName: $nickName, isNickName: $isNickName)
        } customize: {
            $0
                .isOpaque(true)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        }
        .popup(isPresented: $isLogOff, view: {
            LogOffView(isLogOff: $isLogOff, msg: $logoutTip)
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
    
    func getNickName() -> String {
        var nickNames = SystemCaching.nickName
        if nickNames.count > 0 {
            for str in nickNames {
                let to = "<0>"+SystemCaching.phone+"<0>"
                if str.contains(to) {
                    let resultString = str.replacingOccurrences(of: "<0>"+SystemCaching.phone+"<0>", with: "")
                    return resultString
                }
            }
            let nickName = "用户\(Int(arc4random_uniform(10000)))"
            nickNames.append(nickName)
            SystemCaching.nickName = nickNames
            return nickName
        } else {
            let nickName = "用户\(Int(arc4random_uniform(10000)))"
            nickNames.append(nickName)
            SystemCaching.nickName = nickNames
            return nickName
        }
    }
}



#Preview {
    SetView()
}


struct ChangeNicknameView: View {
    @Binding var nickName: String
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
                if nickName.count > 0 {
                    var nickNames = SystemCaching.nickName
                    nickNames.removeAll { str in
                        let to = "<0>"+SystemCaching.phone+"<0>"
                        return str.contains(to)
                    }
                    nickNames.append("<0>"+SystemCaching.phone+"<0>"+nickName)
                    SystemCaching.nickName = nickNames
                }
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
