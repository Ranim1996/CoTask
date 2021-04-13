//
//  AddTaskView.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 10/04/2021.
//

import SwiftUI
import UserNotifications

struct AddTaskView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    
    @State private var title = ""
    @State private var describtion = ""
    @State private var isDone = false
    @State private var forToday = false
    @State private var member = ""
    @State private var priority = "Medium"
    @State private var deadline = Date()

    let members = ["Ranim", "Rawan", "Omar", "Obaida"]

    let priorities = ["High", "Medium", "Low"]
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationView {
            
            Form {
                
                Section (header: Text("Title")){
                    TextField("Title", text: $title)
                }
                
                Section (header: Text("Describtion")){
                    TextField("Describtion", text: $describtion)
                        .padding()
                }
                
                Picker(selection: $priority, label: Text("hi")) {
                    ForEach(priorities, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
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
                         
                        // validate title missing
                        if self.title != "" {
                            let newTask = Task(context: self.moc)
                            newTask.id = UUID()
                            newTask.title = self.title
                            newTask.describtion = self.describtion
                            newTask.member = self.member
                            newTask.priority = self.priority
                            newTask.deadline = self.deadline
                            newTask.isDone = self.isDone
                            newTask.forToday = self.forToday
                            newTask.period = "upcoming"
     
                            do {
                                
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])  {
                                    success, error in
                                        if success {
                                            print("authorization granted")
                                        } else if let error = error {
                                            print(error.localizedDescription)
                                        }
                                }
                                let content = UNMutableNotificationContent()
                                    content.title = "CoTask"
                                    content.body = "Task to be done \(newTask.title ?? "title")"
                                    content.sound = UNNotificationSound.default
                                
                                guard let timeInterval = newTask.deadline?.timeIntervalSinceNow
                                else {
                                    return
                                }
                                
                                try self.moc.save()
                                
                                
                                
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                                
                                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                UNUserNotificationCenter.current().add(request)
                                
                            }
                            catch {
                                print(error)
                            }
                        }
                        else {
                            self.errorShowing = true
                            self.errorTitle = "Title is missing"
                            self.errorMessage = "Make sure the task title at least"
                            return
                        }
                        
                        // close view
                        self.presentationMode.wrappedValue.dismiss()
                        
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(9)
                    .foregroundColor(Color.white)
                }
                
            }
            .navigationBarTitle("Add Task")
            .alert(isPresented: $errorShowing) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

}


struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
