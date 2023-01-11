//
//  TimerCell.swift
//  VRefSolution ios app
//
//  Created by Yassine on 18/12/2022.
//

import SwiftUI

struct TimerCell: View {
    
    var timeUnit: Int
    
    /// Time unit expressed as String.
    /// - Includes "0" as prefix if this is less than 10
    var timeUnitStr: String {
        let timeUnitStr = String(timeUnit)
        return timeUnit < 10 ? "0" + timeUnitStr : timeUnitStr
    }
    
    var body: some View {
        HStack (spacing: 2) {
            Text(timeUnitStr.substring(index: 0)).frame(width: 12)
            Text(timeUnitStr.substring(index: 1)).frame(width: 12)
        }
    }
}

struct TimerCell_Previews: PreviewProvider {
    static var previews: some View {
        TimerCell(timeUnit:5)
    }
}

extension String {
    func substring(index: Int) -> String {
        let arrayString = Array(self)
        return String(arrayString[index])
    }
}
