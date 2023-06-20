//
//  ContentView_DynamicIsland.swift
//  examples
//
//  Created by 1100690 on 2023/06/15.
//

import SwiftUI

struct ContentView_DynamicIsland: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            DynamicIsland(size: size, safeArea: safeArea)
                .ignoresSafeArea()
        }
    }
}

struct ContentView_DynamicIsland_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_DynamicIsland()
    }
}
