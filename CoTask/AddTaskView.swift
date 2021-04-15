//
//  AddTaskView.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 10/04/2021.
//

import SwiftUI
import UserNotifications

struct TitleTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .background(Color.gray.opacity(0.1))
            .cornerRadius(6)
    }
}

struct DescTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 60)
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .background(Color.gray.opacity(0.1))
            .cornerRadius(6)
    }
}



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
                
//                VStack (alignment: .leading){
                
                    Text("Title")
                    TextField("Title", text: $title).modifier(TitleTextFieldModifier())
                    
                    
                    Text("Describtion")
                    .padding(.top, 15)
                    TextField("Describtion", text: $describtion).modifier(DescTextFieldModifier())
                
                    Text("Priority")
                        .padding(.top, 15)
                    Picker(selection: $priority, label: Text("Priority")) {
                        ForEach(priorities, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        
                    Text("Deadline")
                        .padding(.top, 15)
                    DatePicker("Please enter a date", selection: $deadline).labelsHidden()
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))

//                   Section {
                        Picker("Members", selection: $member) {
                            ForEach(members, id: \.self) {
                                Text($0)
                            }
//                        }
                  }.padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))


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
                                    content.body = "Do not forget to finish task: \(newTask.title ?? "title"), the deadline is today."
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
                    .background(Color(0x723452))
                    .cornerRadius(9)
                    .foregroundColor(Color.white)
//                }
                
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
