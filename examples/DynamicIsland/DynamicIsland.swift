//
//  DynamicIsland.swift
//  examples
//
//  Created by 1100690 on 2023/06/15.
//

import SwiftUI

struct DynamicIsland: View {
    var size: CGSize
    var safeArea: EdgeInsets
    @State private var scrollProgress: CGFloat = 0
    @State private var temp: CGSize = .zero
    @Environment(\.colorScheme) private var colorScheme
    
    /*
     safearea.top
     dynamic island iphonses: 50
     notch iphones: 45~47
     notch-less iphones: 0
     */
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                Image("pic2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    ///adding blur and reducing size based on scroll progress
                    .frame(width: 130 - (75 * scrollProgress), height: 130 - (75 * scrollProgress))
                    ///hiding main view so that the dynamic island metaball effect will be visible
                    .opacity(1 - scrollProgress)
                    .blur(radius: scrollProgress * 10)
                    .clipShape(Circle())
                    .anchorPreference(key: AnchorKey.self, value: .bounds, transform: {
                        return ["Header": $0]
                    })
                    .padding(.top, safeArea.top + 15) ///offset이 0부터 시작하도록 offset extractor앞에 패딩 적용
                    .offsetExtractor(coordinateSpace: "SCROLLVIEW") { scrollRect in
                        //convert our offset into progress(0-1)
                        let progress = -scrollRect.minY / 25
                        scrollProgress = min(max(progress, 0), 1)
                    }
                
                Text("moldong:\(scrollProgress), \(temp.height)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.vertical, 15)
                
                sampleRows()
            }
//            .padding(.top, safeArea.top + 15)
            .frame(maxWidth: .infinity)
        }
        ///overlayPreference will disbale all the interactions on our root view. so backgroundPreferenceValue
        .backgroundPreferenceValue(AnchorKey.self, { pref in
            GeometryReader { proxy in
//                Color.clear
//                    .onAppear {
//                        temp = proxy.size
//                    }
                if let anchor = pref["Header"] {
                    let frameRect = proxy[anchor]
                    let isHavingDynamicIsland = safeArea.top > 51
                    let capsuleHeight = isHavingDynamicIsland ? 37 : (safeArea.top - 15)
                    
                    Canvas { out, size in
                        out.addFilter(.alphaThreshold(min: 0.5))
                        out.addFilter(.blur(radius: 12))
                        out.drawLayer { context in
                            if let headerView = out.resolveSymbol(id: 0) {
                                context.draw(headerView, in: frameRect)
                            }
                            
                            if let dynamicIsland = out.resolveSymbol(id: 1) {
                                ///placing dynamic island
                                let rect = CGRect(x: (size.width - 120) / 2, y: isHavingDynamicIsland ? 11 : 0, width: 120, height: capsuleHeight)
                                context.draw(dynamicIsland, in: rect)
                            }
                        }
                    } symbols: {
                        headerView(frameRect)
                            .tag(0)
                            .id(0)
                        dynamicIslandCapsule(capsuleHeight)
                            .tag(1)
                            .id(1)
                    }
                }
            }
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(colorScheme == .dark ? .black : .white)
                    .frame(height: 15)
            }
        })
        .coordinateSpace(name: "SCROLLVIEW")
//        .background(Color.black)
    }
    
    ///canvas symbol
    @ViewBuilder
    func headerView(_ frameRect: CGRect) -> some View {
        Circle()
            .fill(.red)
            .frame(width: frameRect.width, height: frameRect.height)
//            .offset(x: frameRect.minX, y: frameRect.minY)
    }
    
    @ViewBuilder
    func dynamicIslandCapsule(_ height: CGFloat = 37) -> some View {
        Capsule()
//            .fill(.red)
            .frame(width: 120, height: height)
    }
    
    @ViewBuilder
    func sampleRows() -> some View {
        VStack {
            ForEach(1...20, id: \.self) { _ in
                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(.gray.opacity(0.15))
                        .frame(height: 25)
                    
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(.gray.opacity(0.15))
                        .frame(height: 15)
                        .padding(.trailing, 50)
                    
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(.gray.opacity(0.15))
                        .padding(.trailing, 150)
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, safeArea.bottom + 15)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_DynamicIsland()
    }
}
