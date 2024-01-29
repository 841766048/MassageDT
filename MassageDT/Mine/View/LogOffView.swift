//
//  LogOffView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/22.
//

import SwiftUI

struct LogOffView: View {
    @Binding var isLogOff: Bool
    @Binding var msg: String
    var body: some View {
        VStack(spacing: 0) {
            Image("warn")
                .resizable()
                .frame(width: 57, height: 50)
                .padding(.bottom, 20)
            
            
            Text(msg)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 61)
                .font(.system(size: 18))
                .foregroundColor(Color("#1E1E1E"))
            
            HStack(spacing: 25) {
                Button {
                    print("注销")
                    isLogOff = false
                    NetWork.performAccountLogout { val in
                        if val {
                            SystemCaching.clearLogin()
                            RootViewToggle.default.replaceRootView()
                        }
                    }
                } label: {
                    Text("注销")
                        .padding(.horizontal, 48)
                        .padding(.vertical, 12)
                        .foregroundColor(.black)
                        .overlay {
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color("#4D96EB"), lineWidth: 1.5)
                        }
                }
                
                Button {
                    isLogOff = false
                } label: {
                    Text("取消")
                        .padding(.horizontal, 48)
                        .padding(.vertical, 12)
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color("#77AEF7"), Color("#4D96EB")]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(10)
                }
            }
            .padding(.top, 24)
            
            
        }
        .padding(.top, 30)
        .padding(.bottom, 20)
        .frame(maxWidth: screenWidth)
        .background {
            Color.white
        }
        .cornerRadius(9)
        .padding(.horizontal, 25)
        .shadow(color: Color("#4D96EB"), radius: 5)
    }
}

#Preview {
    LogOffView(isLogOff: .constant(false), msg: .constant(""))
}
