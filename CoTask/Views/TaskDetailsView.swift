//
//  TaskDetailsView.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 10/04/2021.
//

import SwiftUI
import CoreData

struct TaskDetailsView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let task: Task
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    // MARK: - BODY
    var body: some View {
        
        // MARK: - GEOMETYREADER
        GeometryReader { geometry in
            
            Color(.systemGray5)
            
            // MARK: - VSTACK
            VStack (alignment: .leading){
                
                // MARK: - TEXTS VIEWS
                Text("Describtion")
                    .modifier(LabelModifier())
                    
                Text(task.describtion ?? "Some information")
                    .modifier(TaskdetailModifier())
                
                
                Text("Priority")
                    .modifier(LabelModifier())
                    
                Text(task.priority ?? "Some information")
                    .modifier(TaskdetailModifier())
                
                
                Text("Member")
                    .modifier(LabelModifier())
                    
                Text(task.member ?? "Some information")
                    .modifier(TaskdetailModifier())
        
                
                Text("Deadline")
                    .modifier(LabelModifier())
                
                Text("\(task.deadline ?? Date(), formatter: self.dateFormatter)")
                    .modifier(TaskdetailModifier())

                
                // MARK: - HSTACK
                HStack {
                    
                    // MARK: - Today BUTTON
                    Button(action: {
                        task.forToday = true
                        task.period = "today"
                        
                        try? self.moc.save()
                        
                        // close view
                        self.presentationMode.wrappedValue.dismiss()
                    }//: TodatBTN
                    , label: {
                        Text("Today")
                    })
                    .modifier(PrimaryButton(maxWidth: geometry.size.width / 2))

                    // MARK: - Upcoming BUTTON
                    Button(action: {
                        task.forToday = false
                        task.period = "upcoming"
                        
                        try? self.moc.save()
                        
                        // close view
                        self.presentationMode.wrappedValue.dismiss()
                    }//: UpcomingBTN
                    , label: {
                        Text("Upcoming")
                    })
                    .modifier(PrimaryButton(maxWidth: geometry.size.width / 2))
                }//: HSTACK
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                
            }//: VSTACK
        }//: GEOMETRYREADER
        .navigationBarTitle(Text(task.title ?? "Unknown Task"), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete Task"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                    self.deleteTask()
                }, secondaryButton: .cancel()
            )
        }//: ALERTDeleteTask
        
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
                .foregroundColor(Color.white)
        })//: TrashICON
        
    }//: BODY
    
    // MARK: - FUNCTIONS
    // delete a task
    func deleteTask() {
        moc.delete(task)
        try? self.moc.save()
        presentationMode.wrappedValue.dismiss()
    }
    
}

// MARK: - PREVIEWPROVIDER
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
