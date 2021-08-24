//
//  LivePerformance.swift
//  RehearsoForWatch Extension
//
//  Created by Mohammad Sulthan on 24/08/21.
//

import SwiftUI

struct LivePerformance: View {
    @State private var runningTimer = 0.0
    @State private var totalTimer = 0.0
    @State var helper = Helper()
    var cue: CueModel
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                VStack {
                    Text("Grab Attention")
                        .font(Font.system(size: 21))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(hex: 0xFFC93C))
                    
                    ProgressView(value: runningTimer, total: totalTimer)
                        .frame(height: 20)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: 0xFFC93C)))
                    
                    Text("State Topic")
                        .font(Font.system(size: 18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .top, spacing: 20, content: {
                        VStack {
                            Text("TIME LEFT")
                                .font(Font.system(size: 12))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.secondary)
                            Text("\(helper.convertSecondToTimeFormat(timer: Int(runningTimer)))")
                                .font(Font.system(size: 27))
                                .onReceive(timer, perform: { _ in
                                    if runningTimer > 1 {
                                        runningTimer -= 1
                                    }
                                })
                        }
                        Spacer()
                        Button(action: {
                            print("Clicked")
                        }) {
                            HStack {
                                Image(systemName: "pause.fill")
                            }
                        }
                        .cornerRadius(9.0)
                    })
                }
            }
        }
        .onAppear {
            totalTimer = Double(cue.duration)
            runningTimer = Double(cue.duration)
        }
    }
}

struct LivePerformance_Previews: PreviewProvider {
    static var previews: some View {
        LivePerformance(cue: cueItems[0])
    }
}
