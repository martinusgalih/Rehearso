//
//  CountdownStart.swift
//  RehearsoForWatch Extension
//
//  Created by Mohammad Sulthan on 24/08/21.
//

import SwiftUI

struct CountdownStart: View {
    @State private var time321 = 3
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var selection: Int? = nil
    @State private var isActive = false
    
    var cue: CueModel
    var rehearse: RehearsalModel
    
    var body: some View {
        VStack {
            Text("\(time321)")
                .font(Font.system(size: 200))
                .foregroundColor(Color(hex: 0xFFC93C))
                .onReceive(timer, perform: { _ in
                    if time321 > 1 {
                        time321 -= 1
                    }
            })
            NavigationLink(destination: LivePerformance(cue: cue), isActive: $isActive) {
                EmptyView()
            }
            .navigationBarBackButtonHidden(true)
            .frame(width: 0, height: 0)
            .navigationBarHidden(true)
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isActive.toggle()
            }
        }
    }
}

struct CountdownStart_Previews: PreviewProvider {
    static var previews: some View {
        CountdownStart(cue: cueItems[0], rehearse: rehearsalItems[0])
    }
}
