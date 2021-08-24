//
//  RehearsalRow.swift
//  RehearsoForWatch Extension
//
//  Created by Mohammad Sulthan on 23/08/21.
//

import SwiftUI

struct RehearsalRow: View {
    var rehearse: RehearsalModel
    
    var body: some View {
        HStack {
            Text(rehearse.name)
        }
    }
}

struct RehearsalRow_Previews: PreviewProvider {
    static var previews: some View {
        RehearsalRow(rehearse: rehearsalItems[0])
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
