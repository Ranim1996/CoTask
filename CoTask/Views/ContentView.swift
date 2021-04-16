//
//  ContentView.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 10/04/2021.
//
//


import SwiftUI
import CoreData
import AVFoundation


struct ContentView: View {
    
    // navbar color
    init() {
        UINavigationBar.appearance().tintColor = UIColor( .white)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor(named: "Primary")
    }

    
    // MARK: - PROPERTIES
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>

    @State private var showingAddScreen = false
    @State private var editingList = false
    @State private var isEditing = false

    
    // MARK: - BODY
    var body: some View {
        
        NavigationView {
            
            List {
                Button(action: {
                    // List today's tasks
                    listTodaysTasks()

                }) {
                    Image("audio")
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                        .padding(EdgeInsets(top: 10, leading: 255, bottom: 0, trailing: 10))
                }

                // List of tasks
                ForEach(Period.allCases, id: \.rawValue) { period in
                    Section(header: Text(period.rawValue)
                                .frame(maxWidth: .infinity, alignment: .center)

                    ) {
                        ForEach(tasks.filter { Period.withLabel($0.period ?? "upcoming") == period && !$0.isDone }, id: \.self) { task in
                            
                            TaskItemView(task: task).frame(height: 60)
                        } //: FOREACH
                    } //: SECTION
                } //: FOREACH
            } //: LIST
            .listStyle(PlainListStyle())
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showingAddScreen.toggle()
            }
            ) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
            })
           .sheet(isPresented: $showingAddScreen) {
               AddTaskView().environment(\.managedObjectContext, self.moc)
           }
        } //: NAVIGATIONVIEW
        .accentColor( .white)
    }

    
    // MARK: - FUNCTIONS
    func listTodaysTasks() {
        let synthesizer = AVSpeechSynthesizer()

        var todayTasks = "Today's tasks are: "
        
        // filter tasks
        let tasksFiltered = tasks.filter { !$0.isDone && $0.period == "today" }


        // loop over tasks
        for (idx, t) in tasksFiltered.enumerated() {
            if !t.isDone && t.period == "today" {

                todayTasks += "\(t.title ?? "") "

                if(idx != tasksFiltered.count - 1) {
                    todayTasks += " and"
                }
            }
        }
        
        if(todayTasks == "Today's tasks are: ") {
            todayTasks = "No tasks for today"
        }

        // speak
        let utterance = AVSpeechUtterance(string: todayTasks)

        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        synthesizer.speak(utterance)
    }
}



  

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
