//
//  Period.swift
//  CoTask
//
//  Created by Rawan Abou Dehn on 15/04/2021.
//

import Foundation

enum Period: String, CaseIterable {
    case today = "Today"
    case upcoming = "Upcoming"
    
    static func withLabel(_ label: String) -> Period? {
        return self.allCases.first{ "\($0)" == label }
    }
}
