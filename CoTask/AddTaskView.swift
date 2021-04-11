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
    @State private var priority = "High"
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
                
                Picker(selection: $priority, label: Text("hi")) {
                    ForEach(priorities, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

//                Text("Value: \(priority)")
                
                Section{
                    DatePicker("Please enter a date", selection: $deadline).labelsHidden()
                }

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
                        newTask.priority = self.priority
                        newTask.deadline = self.deadline
                        newTask.isDone = self.isDone
                        newTask.forToday = self.forToday
                        
                        try? self.moc.save()
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
