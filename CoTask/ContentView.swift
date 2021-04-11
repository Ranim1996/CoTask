//
//  ContentView.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 10/04/2021.
//

import SwiftUI
import CoreData


struct HorizontalLineShape: Shape {

    func path(in rect: CGRect) -> Path {

        let fill = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        var path = Path()
        path.addRoundedRect(in: fill, cornerSize: CGSize(width: 2, height: 2))

        return path
    }
}

struct HorizontalLine: View {
    private var color: Color? = nil
    private var height: CGFloat = 3.0
    private var width: CGFloat = 120.0

    init(color: Color, height: CGFloat = 3.0, width: CGFloat = 120.0) {
        self.color = color
        self.height = height
        self.width = width
    }

    var body: some View {
        HorizontalLineShape().fill(self.color!).frame(minWidth: width, maxWidth: width, minHeight: height, maxHeight: height)
    }
}


enum Period: String, CaseIterable {
    case today = "Today"
    case upcoming = "Upcoming"
    
    static func withLabel(_ label: String) -> Period? {
        return self.allCases.first{ "\($0)" == label }
    }
}


struct ContentView: View {
    // MARK: - PROPERTIES
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>
    

    @State private var showingAddScreen = false

    // MARK: - BODY
    var body: some View {
        NavigationView {
            List {
                ForEach(Period.allCases, id: \.rawValue) { period in
                    Section(header: Text(period.rawValue)
                                .frame(maxWidth: .infinity, alignment: .center)
                    ) {
                        ForEach(tasks.filter { Period.withLabel($0.period ?? "upcoming") == period }, id: \.self) { task in
                            
                            VStack(alignment: .leading) {

                                    Text(task.title ?? "Unknown Title").font(.headline)

                                // Priority
                                if(task.priority == "High") {
                                    HorizontalLine(color: .red)
                                }
                                else if(task.priority == "Medium") {
                                    HorizontalLine(color: .yellow)
                                }
                                else {
                                    HorizontalLine(color: .green)
                                }
                            } //: VSTACK
                        } //: FOREACH
                        .onDelete(perform: deleteTask)
                    } //: SECTION
                    .padding(0)
                } //: FOREACH
            } //: LIST
            //.listStyle(GroupedListStyle())
            .listStyle(PlainListStyle())

            
            
                        

//            List {
//                ForEach(tasks, id: \.self) { task in
//                    NavigationLink(destination: TaskDetailsView(task: task))
//                    {
//
//                        VStack(alignment: .leading) {
//                            Text(task.title ?? "Unknown Title")
//                                .font(.headline)
////                            Text(task.describtion ?? "Unknown Describtion")
////                                .foregroundColor(.secondary)
//                        }
//                    }
//                }
//                .onDelete(perform: deleteTask)
//                .onMove(perform: moveTask)
//
//
//            }

               .navigationBarTitle("Home")
               .navigationBarItems(trailing: Button(action: {
                   self.showingAddScreen.toggle()
               }) {
                   Image(systemName: "plus")
               })
               .sheet(isPresented: $showingAddScreen) {
                   AddTaskView().environment(\.managedObjectContext, self.moc)
               }
       }
    }
    
    // MARK: - FUNCTIONS
    func deleteTask(at offsets: IndexSet) {
        deleteData(entityToFetch: "Task")
        
        for offset in offsets {
            // find this task in our fetch request
            let task = tasks[offset]

            // delete it from the context
            moc.delete(task)
        }

        // save the context
        try? moc.save()
    }
    
    
    private func moveTask(source: IndexSet, destination: Int) {
       // tasks.move(fromOffsets: source, toOffset: destination)
    }
    
    // delete all data
    func deleteData(entityToFetch: String) {
        // 'init()' was deprecated in iOS 9.0: Use -initWithConcurrencyType: instead
        let context = moc

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityToFetch, in: context)
            fetchRequest.includesPropertyValues = false
             do {
                let results = try context.fetch(fetchRequest) as! [NSManagedObject]
                for result in results {
                    context.delete(result)
                }
                try context.save()
               // completion(true)
            } catch {
                //completion(false)
                print("fetch error -\(error.localizedDescription)")
            }
        }
}
  
// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
