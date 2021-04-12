//
//  AddTaskView.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 10/04/2021.
//

import SwiftUI

struct AddTaskView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    
    @State private var title = ""
    @State private var describtion = ""
    @State private var isDone = false
    @State private var forToday = false
    @State private var member = ""
    @State private var priority = ""
    @State private var deadline = Date()

    let members = ["Ranim", "Rawan", "Omar", "Obaida"]

    let priorities = ["High", "Medium", "Low"]
    
    
    var body: some View {
        NavigationView {
            Form {
                Section (header: Text("Title")){
                    TextField("Title", text: $title)
                }
                
                Section (header: Text("Describtion")){
                    TextField("Describtion", text: $describtion)
                }
                
//                Section (header: Text("Priority")){
//                    Picker("Priority", selection: $priority) {
//                          ForEach(0 ..< priorities.count) { index in
//                                 Text(self.priorities[index]).tag(index)
//                           }
//
//                     }.pickerStyle(SegmentedPickerStyle())
//                }

                Section (header: Text("Member")){
                    Picker("Members", selection: $member) {
                        ForEach(members, id: \.self) {
                            Text($0)
                        }
                    }
                }


                Section {
                    Button("Save") {
                        // add the task
                        let newTask = Task(context: self.moc)
                        newTask.title = self.title
                        newTask.describtion = self.describtion
                        newTask.member = self.member
                        newTask.priority = priorities.randomElement()
                        newTask.deadline = self.deadline
                        newTask.isDone = self.isDone
                        newTask.forToday = self.forToday
                        newTask.period = "upcoming"

                        do {
                            print("New task \(newTask)")
                            
                            try self.moc.save()
                            //print("New todo: \(todoItem.name ?? ""), Priority: \(todoItem.priority ?? "")")
                        }
                        catch {
                            print(error)
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("Add Task")
        }
    }

}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
