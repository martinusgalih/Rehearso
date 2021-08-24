//
//  Helper.swift
//  RehearsoForWatch Extension
//
//  Created by Mohammad Sulthan on 24/08/21.
//

import Foundation

class Helper {
    func convertSecondToTimeFormat(timer: Int) -> String {
        let minutes = (timer % 3600) / 60
        let seconds = (timer % 3600) % 60
        
        return String("\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))")
    }
}
