//
//  AddTaskView.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 10/04/2021.
//

import SwiftUI
import UserNotifications


struct AddTaskView: View {
    
    // MARK: - PROPERTIES
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
    

    // MARK: - BODY
    var body: some View {
                
        NavigationView {
                 
            // MARK: - FORM
            Form {
                       
                // MARK: - TextFields & Pickers
                    Text("Title")
                    TextField("Title", text: $title).modifier(TitleFieldModifier())
                    
                    Text("Description")
                    .padding(.top, 15)
                    TextField("Description", text: $describtion).modifier(DescriptionFieldModifier())
                
                    Text("Priority")
                        .padding(.top, 15)
                    Picker(selection: $priority, label: Text("Priority")) {
                        ForEach(priorities, id: \.self) {
                            Text($0)
                        }
                    }//: PriorityPicker
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        
                    Text("Deadline")
                        .padding(.top, 15)
                    DatePicker("Please enter a date", selection: $deadline).labelsHidden()
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))

                    Picker("Members", selection: $member) {
                        ForEach(members, id: \.self) {
                            Text($0)
                        }
                    }//: MemberPicker
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))


                // MARK: - Button
                    Button("Save") {
                        // add the task
                         
                        // validate title missing or not
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
                                permissionNotification(task: newTask)
                                try self.moc.save()
                            }//: DO
                            catch {
                                print(error)
                            }//: CATCH
                        }//: IF
                        else {
                            self.errorShowing = true
                            self.errorTitle = "Title is missing"
                            self.errorMessage = "Make sure the task title at least"
                            return
                        }//: ELSE
                        
                        // close view
                        self.presentationMode.wrappedValue.dismiss()
                        
                    }//: BUTTON
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color(UIColor(named: "Primary")!))
                    .cornerRadius(9)
                    .foregroundColor(Color(UIColor(named: "Accent")!))
                
            }//: FORM
            .navigationBarTitle("Add Task")
            .alert(isPresented: $errorShowing) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }//: ALERTMISSINGTITLE
        }//: NAVVIEW
    }//: BODY
    
    // MARK: - FUNCTIONS
    func permissionNotification(task: Task){
        //when the app is installed and the user enters his first task and date to get notified, a popup with permission request will be shown to allow the app to send notifications
        
        do {
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])  {
                success, error in
                    if success {
                        print("authorization granted")
                    }//: IF
                    else if let error = error {
                        print(error.localizedDescription)
                    }//: ELSE
            }//: AUTHORIZATION
            
            let content = UNMutableNotificationContent()
                content.title = "CoTask"
                content.body = "Do not forget to finish task: \(task.title ?? "title"), the deadline is today."
                content.sound = UNNotificationSound.default
            
            guard let timeInterval = task.deadline?.timeIntervalSinceNow
            else {
                return
            }
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
            
        }//: DO
    }//: FUNCTION
}//: VIEW

// MARK: - PREVIEWPROVIDER
struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
