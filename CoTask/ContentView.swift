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

//used to give the navigation bar some color
struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            if let navigationController = controller.navigationController {
                self.configure(navigationController)
                print("Successfully obtained navigation controller")
            } else {
                print("Failed to obtain navigation controller")
            }
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController,
        context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

//                114, 52, 82
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = 114 / 255
                    g = 52 / 255
                    b = 82 / 255
                    a = CGFloat(hexNumber & 0x000000) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

struct ContentView: View {
    
    // navbar color
    init() {
        UINavigationBar.appearance().barTintColor = UIColor(hex: "#723452ff")
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
                    
                    Image("speak")
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
            
            // give color to the navbar
            .navigationBarTitle("Try it!", displayMode: .inline)
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = .blue
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
            
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
