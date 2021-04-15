//
//  HorizontalLineShape.swift
//  CoTask
//
//  Created by Rawan Abou Dehn on 15/04/2021.
//

import Foundation
import SwiftUI


struct HorizontalLineShape: Shape {
    func path(in rect: CGRect) -> Path {

        let fill = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        var path = Path()
        path.addRoundedRect(in: fill, cornerSize: CGSize(width: 2, height: 2))

        return path
    }
}
