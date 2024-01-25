//
//  TypeView.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/20.
//

import SwiftUI

struct TypeView: View {
    let type: [String] = ["语音", "视频"]
    @Binding var selectedIndex: Int
    let followClickBlock: () -> ()
    var body: some View {
        HStack(spacing: 40) {
            ForEach(type.indices, id: \.self) { index in
                TypeLabelView(title: type[index], index: index, selectedIndex: selectedIndex)
                    .onTapGesture {
                        withAnimation {
                            self.selectedIndex = index
                        }
                    }
            }
            Spacer()
            Button(action: {
                followClickBlock()
            }, label: {
                Text("我的关注")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color("#4E96EB"))
            })
        }
        .backgroundPreferenceValue(MySegementPreferenceKey.self) { preferences in
            GeometryReader { proxy in
                self.createBottomLine(proxy, preferences: preferences)
            }
        }
        .padding(.horizontal, 15)
        .frame(alignment: .leading)
    }
    
    func createBottomLine(_ proxy: GeometryProxy, preferences: [MySegementPreferenceData]) -> some View {
        let p = preferences.first(where: { $0.viewIdx == self.selectedIndex })
        
        let bounds = proxy[p!.bounds]
        
        return RoundedRectangle(cornerRadius: 3.5)
            .foregroundColor(Color("#6FA5F6"))
            .frame(width: bounds.width, height: 7)
            .offset(x: bounds.minX, y: bounds.height - 7)
    }
}

struct TypeLabelView: View {
    let title: String
    let index: Int
    let selectedIndex: Int
    var body: some View {
        Text(title)
            .font(.system(size: 18, weight: index == selectedIndex ? .medium:.regular))
            .foregroundStyle(index == selectedIndex ? Color("#1F1F1F"):Color("#3D3D3D"))
            .anchorPreference(key: MySegementPreferenceKey.self, value: .bounds, transform: {
                [MySegementPreferenceData(viewIdx: index, bounds: $0)]
            })
            .transformAnchorPreference(key: MySegementPreferenceKey.self, value: .topLeading, transform: { (value: inout [MySegementPreferenceData], anchor: Anchor<CGPoint>) in
                value[0].topLeading = anchor
            })
    }
}


struct MySegementPreferenceData {
    let viewIdx: Int
    let bounds: Anchor<CGRect>
    var topLeading: Anchor<CGPoint>? = nil
}

struct MySegementPreferenceKey: PreferenceKey {
    typealias Value = [MySegementPreferenceData]
    static var defaultValue: Value = []
    static func reduce(value: inout [MySegementPreferenceData], nextValue: () -> [MySegementPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

#Preview {
    TypeView(selectedIndex: .constant(0), followClickBlock: {})
}

