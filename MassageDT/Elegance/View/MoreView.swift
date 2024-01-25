//
//  MoreView.swift
//  TFSwiftUI
//
//  Created by 张海彬 on 2024/1/20.
//

import SwiftUI
import ProgressHUD

struct MoreView: View {
    var blockBlock: ((String) -> Void)?
    var reportBlock: ((String) -> Void)?
    @Binding var isMore: Bool
    
    
    @State var selectIndex = 0
    @State var isNext = false
    // 举报/拉黑 描述
    @State var copywriting = ""
    init(isMore: Binding<Bool>, blockBlock: ((String) -> Void)? = nil, reportBlock: ((String) -> Void)? = nil) {
        _isMore = isMore
        self.blockBlock = blockBlock
        self.reportBlock = reportBlock
    }
    var body: some View {
        switch isNext {
        case false:
            VStack {
                Text("请选择反馈类型")
                    .font(.system(size: 18))
                    .foregroundStyle(Color("#1E1E1E"))
                HStack(spacing: 24) {
                    Button {
                        withAnimation {
                            selectIndex = 0
                        }
                    } label: {
                        Text("我要拉黑")
                            .foregroundStyle(selectIndex == 0 ? Color("#4E96EB"):Color("#1E1E1E"))
                            .padding(.horizontal, 31)
                            .padding(.vertical, 12)
                            .overlay(content: {
                                RoundedRectangle(cornerRadius: 7)
                                    .stroke(selectIndex == 0 ? Color("#4D96EB"): Color("#5A5A5A"), lineWidth: 1.5)
                            })
                    }
                    
                    Button {
                        withAnimation {
                            selectIndex = 1
                        }
                    } label: {
                        Text("我要举报")
                            .foregroundStyle(selectIndex != 0 ? Color("#4E96EB"):Color("#1E1E1E"))
                            .padding(.horizontal, 31)
                            .padding(.vertical, 12)
                            .overlay(content: {
                                RoundedRectangle(cornerRadius: 7)
                                    .stroke(selectIndex != 0 ? Color("#4D96EB"): Color("#5A5A5A"), lineWidth: 1.5)
                            })
                    }
                }
                .padding(.top, 37)
                Button {
                    isNext = true
                } label: {
                    Text("下一步")
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
            .frame(maxWidth: screenWidth)
            .padding(.vertical, 25)
            .background {
                Color.white
            }
            .cornerRadius(9)
            .padding(.horizontal, 25)
        default:
            VStack {
                Text(selectIndex == 0 ? "请输入拉黑描述":"请输入举报描述")
                    .font(.system(size: 18))
                    .foregroundStyle(Color("#1E1E1E"))
                TextArea(selectIndex == 0 ? "请输入拉黑描述":"请输入举报描述", text: $copywriting)
                    .frame(maxWidth: screenWidth)
                    .frame(height: 150)
                    .border(Color("#5A5A5A"), width: 0.5)
                    .padding(.horizontal, 17)
                    
                Button {
                    if copywriting.count == 0 {
                        ProgressHUD.failed("请填写内容")
                        return
                    }
                    if selectIndex == 0 {
                        blockBlock?(copywriting)
                    } else {
                        reportBlock?(copywriting)
                    }
                    isMore = false
                } label: {
                    Text("提交")
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
            .frame(maxWidth: screenWidth)
            .padding(.top, 25)
            .padding(.bottom, 20)
            .background {
                Color.white
            }
            .cornerRadius(9)
            .padding(.horizontal, 25)
        }
        

    }
}

#Preview {
    MoreView(isMore: .constant(false))
}

struct TextArea: View {
    private let placeholder: String
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        UITextView.appearance().backgroundColor = .clear
        self.placeholder = placeholder
        _text = text
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                VStack {
                    Text(placeholder)
                        .font(.system(size: 14))
                        .padding(.top, 10)
                        .padding(.leading, 6)
                        .foregroundColor(Color("#5A5A5A"))
                        .opacity(0.6)
                        .allowsHitTesting(true)
                    Spacer()
                }
               
            }
            VStack {
                TextEditor(text: $text)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .background {
                        Color.clear
                    }
                    .k_scrollContentBackgroundHiden()
                Spacer()
            }
        }.background {
            Color.white
        }
    }
}

extension View {
    func k_scrollContentBackgroundHiden() ->  some View {
        if #available(iOS 16.0, *) {
            return self.scrollContentBackground(.hidden)
        } else {
            return self
        }
    }
}

extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}
