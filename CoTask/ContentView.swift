//
//  ContentView.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 10/04/2021.
//

import SwiftUI
import CoreData



struct ContentView: View {
    // MARK: - PROPERTIES
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>
    

    @State private var showingAddScreen = false
    
    @State var offset = CGSize.zero
    @State var offsetY : CGFloat = 0
    @State var scale : CGFloat = 0.5
    

    // MARK: - BODY
    var body: some View {
        NavigationView {
            List {
                //Text("\(tasks.count)")
                ForEach(Period.allCases, id: \.rawValue) { period in
                    Section(header: Text(period.rawValue)
                                .frame(maxWidth: .infinity, alignment: .center)
                    ) {
                        ForEach(tasks.filter { Period.withLabel($0.period ?? "upcoming") == period }, id: \.self) { task in
                            
                            //TaskItemView(task: task)
                            NavigationLink(destination: TaskDetailsView(task: task)){
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
                            } //: NAVIGATIONLINK
                        } //: FOREACH
                        .onDelete(perform: deleteTask)
                    } //: SECTION
                    .padding(0)
                } //: FOREACH
            } //: LIST
            //.listStyle(GroupedListStyle())
            .listStyle(PlainListStyle())
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
       // deleteData(entityToFetch: "Task")
        
        for offset in offsets {
            print("\(offsets)")
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
    
    // Delete all data
    // https://stackoverflow.com/questions/1383598/core-data-quickest-way-to-delete-all-instances-of-an-entity
    func deleteData(entityToFetch: String) {
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
            } catch {
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
