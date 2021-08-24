//
//  RehearsalView.swift
//  RehearsoForWatch Extension
//
//  Created by Mohammad Sulthan on 23/08/21.
//

import SwiftUI

struct RehearsalView: View {
    var cue: CueModel
    
    var body: some View {
        RehearsalList(cueItem: cue)
    }
}

struct RehearsalView_Previews: PreviewProvider {
    static var previews: some View {
        RehearsalView(cue: cueItems[0])
    }
}
