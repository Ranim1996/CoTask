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
        // 114, 52, 82
        UINavigationBar.appearance().barTintColor = UIColor(hex: "#723452ff", red: 114, green: 52, blue: 82)
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
                
//                Color(.systemGray5)
                
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

                    
                    
                    
                    var todayTasks = "Today's tasks are: "


                    //for t in tasks {
                    for (idx, t) in tasks.enumerated() {
                        if !t.isDone && t.period == "today" {

                            todayTasks += "\(t.title ?? "") and"

//                            if(idx != tasks.count - 1) {
//                                todayTasks += " and"
//                            }
                        }
                    }
                    
                    //let stringLength = count(name) // Since swift1.2 `countElements` became `count`
                    //let substringIndex = todayTasks.count - 3
                    


                    if(todayTasks == "Today's tasks are: ") {
                        todayTasks = "No tasks for today"
                    }
                    else {
                        let start = todayTasks.index(todayTasks.startIndex, offsetBy: 0)
                        let end = todayTasks.index(todayTasks.endIndex, offsetBy: -3)
                        let range = start..<end

                        let mySubstring = todayTasks[range]  // play
                        
                        todayTasks = String(mySubstring)
                    }

                    

                    let utterance = AVSpeechUtterance(string: todayTasks)

                    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

                    synthesizer.speak(utterance)

                }) {
                    
                    Image("audio")
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                        .padding(EdgeInsets(top: 10, leading: 255, bottom: 0, trailing: 10))
                    
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
            //.listStyle(GroupedListStyle())
            .listStyle(PlainListStyle())
           .navigationBarTitle("Home")
            .background(Color(0xE5E5EA))
            .foregroundColor(.white)

            // give color to the navbar
            .navigationBarTitle("Try it!", displayMode: .inline)

            
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
        }
        .accentColor( .white)
        //.background(Color(0xE5E5EA))
    }

    // MARK: - FUNCTIONS
}

  

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }

}
