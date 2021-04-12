//
//  TaskItemView.swift
//  CoTask
//
//  Created by Rawan Abou Dehn on 12/04/2021.
//

import SwiftUI
import CoreData

struct TaskItemView: View {
    @Environment(\.managedObjectContext) var moc

    let task: Task

    var body: some View {
        NavigationLink(destination: TaskDetailsView(task: task)){
            VStack(alignment: .leading) {

                Text(task.title ?? "Unknown Title").font(.headline)

                // Priority
                if(task.priority == "High") {
                    HorizontalLine(color: .red)
                }
                else if(task.priority == "Medium") {
                    HorizontalLine(color: .yellow)
                }
                else {
                    HorizontalLine(color: .green)
                }
        
                
            } //: VSTACK
        } //: NAVIGATIONLINK
    }
}


struct HorizontalLineShape: Shape {

    func path(in rect: CGRect) -> Path {

        let fill = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        var path = Path()
        path.addRoundedRect(in: fill, cornerSize: CGSize(width: 2, height: 2))

        return path
    }
}

struct HorizontalLine: View {
    private var color: Color? = nil
    private var height: CGFloat = 4.0
    private var width: CGFloat = 120.0

    init(color: Color, height: CGFloat = 4.0, width: CGFloat = 120.0) {
        self.color = color
        self.height = height
        self.width = width
    }

    var body: some View {
        HorizontalLineShape().fill(self.color!).frame(minWidth: width, maxWidth: width, minHeight: height, maxHeight: height)
    }
}

enum Period: String, CaseIterable {
    case today = "Today"
    case upcoming = "Upcoming"
    
    static func withLabel(_ label: String) -> Period? {
        return self.allCases.first{ "\($0)" == label }
    }
}

struct TaskItemView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let task = Task(context: moc)
        task.title = "Task"
        task.describtion = "Some information"
        task.member = "Ranim"
        task.priority = "High"

        return NavigationView {
            TaskItemView(task: task)
        }
    }
}
