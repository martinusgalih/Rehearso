//
//  PreviewSection.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 09/08/21.
//

import Foundation

struct SectionPreview {
    var title: String!
    var expanded: Bool

    init(title: String, expanded: Bool) {
        self.title = title
        self.expanded = expanded
    }
}

var sectionsPreview : [SectionPreview] = [
    SectionPreview(title: "Grab Attention", expanded: true),
    SectionPreview(title: "Reason To Listen", expanded: true),
    SectionPreview(title: "State Topic", expanded: true),
    SectionPreview(title: "Credibility Statement", expanded: true),
    SectionPreview(title: "Preview Statement", expanded: true),
    SectionPreview(title: "Introduce your topic", expanded: true),
    SectionPreview(title: "Explain your point", expanded: true),
    SectionPreview(title: "Transition to next point", expanded: true),
    SectionPreview(title: "Summary", expanded: true),
    SectionPreview(title: "Closure", expanded: true)]


