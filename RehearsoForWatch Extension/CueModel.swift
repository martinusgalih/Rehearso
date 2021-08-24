//
//  CueModel.swift
//  RehearsoForWatch Extension
//
//  Created by Mohammad Sulthan on 24/08/21.
//

import Foundation

struct CueModel: Hashable, Codable, Identifiable {
    var id = UUID()
    var name: String
    var duration: Int
}

let cueItems = [
    CueModel(name: "Cue Card 1", duration: 30),
    CueModel(name: "Cue Card 2", duration: 60)
]
