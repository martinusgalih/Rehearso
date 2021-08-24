//
//  RehearsalList.swift
//  RehearsoForWatch Extension
//
//  Created by Mohammad Sulthan on 24/08/21.
//

import SwiftUI

struct RehearsalList: View {
    var cueItem: CueModel
    
    var body: some View {
        VStack {
            Text(cueItem.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color(hex: 0xFFC93C))
            List(rehearsalItems) { item in
                NavigationLink(destination: StartPerformance(cue: cueItem, rehearse: item)) {
                    RehearsalRow(rehearse: item)
                }
            }.colorMultiply(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
        }
        .padding()
    }
}

struct RehearsalList_Previews: PreviewProvider {
    static var previews: some View {
        RehearsalList(cueItem: cueItems[0])
    }
}
