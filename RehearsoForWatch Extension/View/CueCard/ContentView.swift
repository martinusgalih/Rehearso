//
//  ContentView.swift
//  RehearsoForWatch Extension
//
//  Created by Mohammad Sulthan on 19/08/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CueCardList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
