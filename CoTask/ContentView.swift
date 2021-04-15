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



//extension UIColor {
//
//    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
//
//        let normalizedRed = CGFloat(red) / 255
//        let normalizedGreen = CGFloat(green) / 255
//        let normalizedBlue = CGFloat(blue) / 255
//
//        self.init(red: normalizedRed, green: normalizedGreen, blue: normalizedBlue, alpha: alpha)
//    }
//}
////Usage:
//
//let newColor: UIColor = UIColor.init(red: 74, green: 74, blue: 74, alpha: 1)

//prefix operator ⋮
//prefix func ⋮(hex:UInt32) -> Color {
//    return Color(hex)
//}
//
//extension Color {
//    init(_ hex: UInt32, opacity:Double = 1.0) {
//        let red = Double((hex & 0xff0000) >> 16) / 255.0
//        let green = Double((hex & 0xff00) >> 8) / 255.0
//        let blue = Double((hex & 0xff) >> 0) / 255.0
//        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
//    }
//}
//
//let hexColor:(UInt32) -> (Color) = {
//    return Color($0)
//}
//
//extension UIColor {
//    var suColor: Color { Color(self) }
//
//    
//    public convenience init?(hex: String, red: Int, green: Int, blue: Int) {
//        let r, g, b, a: CGFloat
//
//        if hex.hasPrefix("#") {
//            let start = hex.index(hex.startIndex, offsetBy: 1)
//            let hexColor = String(hex[start...])
//
//            if hexColor.count == 8 {
//                let scanner = Scanner(string: hexColor)
//                var hexNumber: UInt64 = 0
//
////                114, 52, 82
//                
//                if scanner.scanHexInt64(&hexNumber) {
//                    r = CGFloat(red)  / 255
//                    g = CGFloat(green) / 255
//                    b = CGFloat(blue) / 255
//                    a = CGFloat(hexNumber & 0x000000) / 255
//
//                    self.init(red: r, green: g, blue: b, alpha: a)
//                    return
//                }
//            }
//        }
//
//        return nil
//    }
//}

struct ContentView: View {
    
    
    // navbar color
    init() {
        // 114, 52, 82
        UINavigationBar.appearance().barTintColor = UIColor(hex: "#723452ff", red: 114, green: 52, blue: 82)
        UINavigationBar.appearance().tintColor = UIColor(hex: "#FFFFFFff", red: 255, green: 255, blue: 255)
        
        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
//        UIButton.appearance().tintColor = UIColor(hex: "#723452ff", red: 114, green: 52, blue: 82)
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
        .background(Color(0xE5E5EA))
    }

    // MARK: - FUNCTIONS
}

  

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }

}
