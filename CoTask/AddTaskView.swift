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
                        newTask.id = UUID()
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
                        
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                        
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request)
                        
//                        UNUserNotificationCenter.current()
//                            .requestAuthorization(options: [.alert, .badge, .sound]) {
//                                success, error in
//                                if (success){
//                                    print("Success!!")
//                                    let content = UNMutableNotificationContent()
//                                    content.title = "Co Task"
//                                    content.subtitle = "Task to be done"
//                                    content.sound = UNNotificationSound.default
//
//                                    newTask.deadline = Date()
//                                    var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: newTask.deadline!)
//                                    dateComponents.hour = 16
//                                    dateComponents.minute = 23
//
//                                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//
//                                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//                                    UNUserNotificationCenter.current().add(request)
//                            } else if let error = error {
//                                print(error.localizedDescription)
//                            }
//                        }
                    }
                }
            }
            .navigationBarTitle("Add Task")
        }
    }
    
    func scheduleNotification(task: Task) {
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
        content.body = "Tomar \(task.title ?? "title")"
            content.sound = UNNotificationSound.default
        
        guard let timeInterval = task.deadline?.timeIntervalSinceNow
        else {
            return
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
