//
//  RehearsalModel.swift
//  RehearsoForWatch Extension
//
//  Created by Mohammad Sulthan on 24/08/21.
//

import Foundation

struct RehearsalModel: Hashable, Codable, Identifiable {
    var id = UUID()
    var name: String
    var duration: Int
}

let rehearsalItems = [
    RehearsalModel(name: "Rehearsal 1", duration: 30),
    RehearsalModel(name: "Rehearsal 2", duration: 60)
]
