//
//  StartPerformance.swift
//  RehearsoForWatch Extension
//
//  Created by Mohammad Sulthan on 24/08/21.
//

import SwiftUI

struct StartPerformance: View {
    var cue: CueModel
    var rehearse: RehearsalModel
    @State var selection: Int? = nil
    var helper = Helper()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(cue.name)
                            .font(Font.system(size: 17))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color(hex: 0xFFC93C))
                        Text(rehearse.name)
                            .font(Font.system(size: 17))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Duration \(helper.convertSecondToTimeFormat(timer: cue.duration))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(Font.system(size: 17))
                            .foregroundColor(.secondary)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Note")
                            .font(Font.system(size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color(hex: 0xFFC93C))
                        Text("Dont forget to control your breathing pattern")
                            .font(Font.system(size: 14))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.secondary)
                    }
                    
                    NavigationLink(destination: CountdownStart(cue: cue, rehearse: rehearse), tag: 1, selection: $selection) {
                        Text("Start")
                        EmptyView()
                    }
                    .background(Color(hex: 0x185ADB))
                    .cornerRadius(9.0)
                    .frame(height: 44, alignment: .center)
                }
                .padding()
            }
        }
    }
}

struct StartPerformance_Previews: PreviewProvider {
    static var previews: some View {
        StartPerformance(cue: cueItems[0], rehearse: rehearsalItems[0])
    }
}
