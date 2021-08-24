//
//  CueCardRow.swift
//  RehearsoForWatch Extension
//
//  Created by Mohammad Sulthan on 20/08/21.
//

import SwiftUI

struct CueCardRow: View {
    var cue: CueModel
    
    var body: some View {
        HStack {
            Text(cue.name)
        }
    }
}

struct CueCardRow_Previews: PreviewProvider {
    static var previews: some View {
        CueCardRow(cue: cueItems[0])
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
