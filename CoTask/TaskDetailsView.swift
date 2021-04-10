//
//  TaskDetailsView.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 10/04/2021.
//

import SwiftUI
import CoreData

struct TaskDetailsView: View {
    
    let task: Task
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack (alignment: .leading , spacing: 3.50){
            
            Text("Describtion")
                .font(.headline)
            Text(task.describtion ?? "Some information")
                .foregroundColor(.secondary)
            
//            Spacer()
            
            Text("Priority")
                .font(.headline)
            Text(task.priority ?? "Some information")
                .foregroundColor(.secondary)
            
//            Spacer()
            
            Text("Member")
                .font(.headline)
            Text(task.member ?? "Some information")
                .foregroundColor(.secondary)
    
            }
        }
        .navigationBarTitle(Text(task.title ?? "Unknown Task"), displayMode: .inline)
        
    }
}

struct TaskDetailsView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let task = Task(context: moc)
        task.title = "Tesk"
        task.describtion = "Some information"
        task.member = "Ranim"
        task.priority = "High"

        return NavigationView {
            TaskDetailsView(task: task)
        }
    }
}
