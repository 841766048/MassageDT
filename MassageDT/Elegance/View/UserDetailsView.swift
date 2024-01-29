//
//  UserDetailsView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/22.
//

import SwiftUI
import SDWebImageSwiftUI
import ExytePopupView
import ProgressHUD

class UserDetailsViewModel: ObservableObject {
    var followListClick:(() -> ())?
    var albumListClick:(() -> ())?
    @Published var itemModel: ElegantModel = ElegantModel()
    
}


struct UserDetailsTopView: View {
    let itemModel: ElegantModel
    @State var isMore = false
    @State var isFollow = false
    @State var isCancelFollow = false
    
    @State var userFollow = false
    let followListClick:(() -> ())?
    @AppStorage("followList") var followList = SystemCaching.followList
    var body: some View {
        HStack {
            WebImage(url: URL(string: itemModel.userAvatar))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(40)
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0, content: {
                    Text(itemModel.nickname)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.bottom, 14)
                        .padding(.trailing, 30)
                    
                    Button(action: {
                        if userFollow {
                            isCancelFollow = true
                        } else {
                            var set = Set(SystemCaching.followList)
                            set.insert(self.itemModel.id)
                            SystemCaching.followList = Array(set)
                            userFollow = true
                            isFollow = true
                        }
                    }, label: {
                        HStack(spacing: 7.5) {  
                            Image(userFollow ? "已关注":"add")
                                .resizable()
                                .frame(width: 8,height: 8)
                            Text(userFollow ? "已关注":"关注")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(Color("#4E96EB"))
                        }
                        .padding(.horizontal, 5.5)
                        .padding(.vertical, 6.5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(Color("#4E96EB"), lineWidth: 0.5)
                        }
                    })
                    
                    Spacer()
                    
                    Text(itemModel.cityName)
                        .foregroundStyle(Color("#3C3C3C"))
                        .font(.system(size: 14))
                })
                HStack(spacing: 10) {
                    ForEach(itemModel.userTags.indices, id:\.self) { index in
                        Text(itemModel.userTags[index])
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color("#4E96EB"))
                    }
                }
                .padding(.bottom, 14)
                HStack {
                    Button {
                        if let url = URL(string: itemModel.audioSrc) {
                            AudioManager.shared.playAudio(from: url)
                        }
                    } label: {
                        ZStack(alignment: .trailing) {
                            Image("yuyin")
                            Text("")
                                .foregroundStyle(.white)
                                .padding(.trailing, 20)
                        }
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
                NetWork.blackRequest(msg: value) { val in
                    if val {
                        var set = Set(SystemCaching.blackList)
                        set.insert(itemModel.id)
                        SystemCaching.blackList = Array(set)
                        ProgressHUD.succeed("拉黑成功")
                        
                        var followset = Set(SystemCaching.followList)
                        followset.remove(itemModel.id)
                        SystemCaching.followList = Array(followset)
                        
                        RootViewToggle.default.updateEleganceData()
                    }
                }
            } reportBlock: { value in
                NetWork.blackRequest(msg: value) { val in
                    if val {
                        ProgressHUD.succeed("举报成功")
                    }
                }
            }
        } customize: {
            $0
                .isOpaque(true)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        }
        .popup(isPresented: $isFollow) {
            FollowTipsView(isShow:  $isFollow, message: "关注成功", firstTitle: "好的", firstClick: {
            } , lastTitle: "关注列表") {
                followListClick?()
            }
        } customize: {
            $0
                .isOpaque(true)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        }
        .popup(isPresented: $isCancelFollow) {
            FollowTipsView(isShow:  $isCancelFollow, message: "确认取消关注吗？", firstTitle: "确认", firstClick: {
                var set = Set(SystemCaching.followList)
                set.remove(self.itemModel.id)
                SystemCaching.followList = Array(set)
                userFollow = false
            } , lastTitle: "关闭") {
                
            }
        } customize: {
            $0
                .isOpaque(true)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        }
        .onAppear {
            userFollow = SystemCaching.followList.contains("\(self.itemModel.id)")
        }

    }
}


struct UserDetailsView: View {
    @ObservedObject var viewModel: UserDetailsViewModel
    @State var clickURLAvatar: String = ""
    @State var isImageShow = false
    var body: some View {
        ScrollView {
            UserDetailsTopView(itemModel: viewModel.itemModel, followListClick: {
                viewModel.followListClick?()
            })
            WebImage(url: URL(string: viewModel.itemModel.userAvatar))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: screenWidth)
            
            HStack(content: {
                Text("TA的相册")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color("#1E1E1E"))
                Spacer()
                
                Button(action: {
                    viewModel.albumListClick?()
                }, label: {
                    Text("全部")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color("#3C3C3C"))
                    Image("right_icon")
                        .resizable()
                        .frame(width: 5.5, height: 10)
                })
            })
            .padding(.horizontal, 15)
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), content: {
                ForEach(viewModel.itemModel.partUserAlbums, id: \.self) { indx in
                    WebImage(url: URL(string: indx))
                        .placeholder(Image("图片缺失"))
                        .resizable()
                        .frame(width: 110 ,height: 121)
                        .clipped()
                        .onTapGesture {
                            clickURLAvatar = indx
                            isImageShow = true
                        }
                    
                }
            })
        }
        .background {
            Color("#FAFAFA")
        }
        .popup(isPresented: $isImageShow) {
            ImageShowView(imgaeURL: $clickURLAvatar
            )
        } customize: {
            $0
                .isOpaque(true)
//                .closeOnTap(true)
                .backgroundColor(.black.opacity(0.4))
        }
    }
}



struct FollowTipsView: View {
    @Binding var isShow: Bool
    let message: String
    let firstTitle: String
    let firstClick: (() -> ())?
    
    let lastTitle: String
    let lastClick: (() -> ())?
    
    var body: some View {
        VStack(spacing: 0) {
            Text(message)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 61)
                .font(.system(size: 18))
                .foregroundColor(Color("#1E1E1E"))
            
            HStack(spacing: 25) {
                Button {
                    isShow = false
                    firstClick?()
                } label: {
                    Text(firstTitle)
                        .frame(width: 130, height: 40)
                        .foregroundColor(.black)
                        .overlay {
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color("#4D96EB"), lineWidth: 1.5)
                        }
                }
                
                Button {
                    isShow = false
                    lastClick?()
                } label: {
                    Text(lastTitle)
                        .frame(width: 130, height: 40)
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color("#77AEF7"), Color("#4D96EB")]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(10)
                }
            }
            .padding(.top, 24)
            
            
        }
        .padding(.top, 40)
        .padding(.bottom, 26)
        .frame(maxWidth: screenWidth)
        .background {
            Color.white
        }
        .cornerRadius(9)
        .padding(.horizontal, 25)
        .shadow(color: Color("#4D96EB"), radius: 5)
    }
}
