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
    @State private var textHeaderOffset: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    
    /*
     safearea.top
     dynamic island iphonses: 50
     notch iphones: 45~47
     notch-less iphones: 0
     */
    
    var body: some View {
        let isHavingNotch = safeArea.bottom != 0
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
                        guard isHavingNotch else { return }
                        //convert our offset into progress(0-1)
                        let progress = -scrollRect.minY / 25
                        scrollProgress = min(max(progress, 0), 1)
                    }
                
                let fixedTop: CGFloat = safeArea.top + 3 //스티키시 3만큼 horizontal align 조절
                Text("moldong:\(scrollProgress), \(temp.height)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.vertical, 15)
                    .background {
                        Rectangle()
                            .fill(colorScheme == .dark ? .black : .white)
                            .frame(width: size.width)
                            .padding(.top, textHeaderOffset < fixedTop ? -safeArea.top : 0)
                            .shadow(color: .black.opacity(textHeaderOffset < fixedTop ? 0.1 : 0), radius: 5, x: 0, y: 5)
                    }
                    ///stopping at the top
                    .offset(y: textHeaderOffset < fixedTop ? -(textHeaderOffset - fixedTop) : 0)
                    .offsetExtractor(coordinateSpace: "SCROLLVIEW") {
                        textHeaderOffset = $0.minY
                    }
                    .zIndex(1000)
                
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
                if let anchor = pref["Header"], isHavingNotch {
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
        .overlay(alignment: .top, content: {
            HStack {
                Button {
                    
                } label: {
                    Label("Back", systemImage: "chevron.left")
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Edit")
                }
            }
            .padding(15)
            .padding(.top, safeArea.top)
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
