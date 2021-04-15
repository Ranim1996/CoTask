//
//  TaskDetailsView.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 10/04/2021.
//

import SwiftUI
import CoreData



struct TaskDetailsView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let task: Task
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            Color(.systemGray5)
//                .overlay(
            VStack (alignment: .leading){

                Text("Describtion")
                    .font(.headline)
                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
                    
                Text(task.describtion ?? "Some information")
                    .foregroundColor(.secondary)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                
                
                Text("Priority")
                    .font(.headline)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                    
                Text(task.priority ?? "Some information")
                    .foregroundColor(.secondary)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                
                
                Text("Member")
                    .font(.headline)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                    
                Text(task.member ?? "Some information")
                    .foregroundColor(.secondary)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
        
                
                Text("Deadline")
                    .font(.headline)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                
                Text("\(task.deadline ?? Date(), formatter: self.dateFormatter)")
                    .foregroundColor(.secondary)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))

                
                HStack {
                    Button(action: {
                        task.forToday = true
                        task.period = "today"
                        
                        // close view
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Today")
                    })
                    .modifier(PrimaryButton(maxWidth: geometry.size.width / 2))

                    Button(action: {
                        task.forToday = false
                        task.period = "upcoming"
                        
                        // close view
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Upcoming")
                    })
                    .modifier(PrimaryButton(maxWidth: geometry.size.width / 2))
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                
            }
//            )
        }
        .navigationBarTitle(Text(task.title ?? "Unknown Task"), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete Task"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                    self.deleteTask()
                }, secondaryButton: .cancel()
            )
        }
        
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
                .foregroundColor(Color.white)
        })
        
    }
    
    func deleteTask() {
        moc.delete(task)

        // uncomment this line if you want to make the deletion permanent
        try? self.moc.save()
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct TaskDetailsView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let task = Task(context: moc)
        task.title = "Task"
        task.describtion = "Some information"
        task.member = "Ranim"
        task.priority = "High"
        task.deadline = Date()

        return NavigationView {
            TaskDetailsView(task: task)
        }
    }
}
