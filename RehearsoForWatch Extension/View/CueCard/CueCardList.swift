//
//  CueCardList.swift
//  RehearsoForWatch Extension
//
//  Created by Mohammad Sulthan on 24/08/21.
//

import SwiftUI

struct CueCardList: View {
    var body: some View {
        List(cueItems) { item in
            NavigationLink(
                destination: RehearsalView(cue: item)) {
                    CueCardRow(cue: item)
            }
        }
        .navigationTitle("Rehearso")
        .padding()
    }
}

struct CueCardList_Previews: PreviewProvider {
    static var previews: some View {
        CueCardList()
    }
}
