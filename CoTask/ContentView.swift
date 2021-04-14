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
                let synthesizer = AVSpeechSynthesizer()
                Button(action: {

//                    for t in tasks {

//                        if !t.isDone {

//                            let utterance = AVSpeechUtterance(string: t.title ?? "no")

//                            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

//

//                            synthesizer.speak(utterance)

//                        }

//                    }

                    
                    var todayTasks = ""

                    //for t in tasks {
                    for (idx, t) in tasks.enumerated() {
                        if !t.isDone && t.period == "today" {
                            if(idx == 0) {
                                todayTasks = "Today's tasks are: "
                            }

                            todayTasks += "\(t.title ?? "") "

                            if(idx != tasks.count - 1) {
                                todayTasks += " and"
                            }
                        }
                    }

                    if(todayTasks == "") {
                        todayTasks = "No tasks for today"
                    }
                    

                    let utterance = AVSpeechUtterance(string: todayTasks)

                    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

                    synthesizer.speak(utterance)

                }) {
                    
                    Image("speaker")
                        .padding(EdgeInsets(top: 10, leading: 250, bottom: 0, trailing: 10))
                    
//                    Text("Speak out")
                }

                ForEach(Period.allCases, id: \.rawValue) { period in
                    Section(header: Text(period.rawValue)
                                .frame(maxWidth: .infinity, alignment: .center)

                    ) {
                        ForEach(tasks.filter { Period.withLabel($0.period ?? "upcoming") == period && !$0.isDone }, id: \.self) { task in
                            
                            
                            TaskItemView(task: task).frame(height: 60)
                                

                        } //: FOREACH
//                        .onMove(perform: moveTask)
//                        .onLongPressGesture {
//                            withAnimation {
//                                self.editingList = true
//                            }
//                        }
                    } //: SECTION

                } //: FOREACH

            } //: LIST
            .listStyle(GroupedListStyle())
            //.listStyle(PlainListStyle())
           .navigationBarTitle("Home")
            .navigationBarItems(trailing: Button(action: {
                self.showingAddScreen.toggle()
            }
            ) {
                Image(systemName: "plus")
            })
           .sheet(isPresented: $showingAddScreen) {
               AddTaskView().environment(\.managedObjectContext, self.moc)

           }
        }
    }

    // MARK: - FUNCTIONS
    private func moveTask(fromOffsets source: IndexSet, toOffset destination: Int) {
        //tasks.move(fromOffsets: source, toOffset: destination)
        
        withAnimation {
            editingList = false
        }
    }
}

  

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }

}
