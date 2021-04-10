//
//  ContentView.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 10/04/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>


    @State private var showingAddScreen = false

    var body: some View {
        NavigationView {
            List {
                ForEach(tasks, id: \.self) { task in
                    NavigationLink(destination: TaskDetailsView(task: task))
                    {

                        VStack(alignment: .leading) {
                            Text(task.title ?? "Unknown Title")
                                .font(.headline)
//                            Text(task.describtion ?? "Unknown Describtion")
//                                .foregroundColor(.secondary)
                        }
                    }
                }.onDelete(perform: deleteTasks)
            }
            
               .navigationBarTitle("Add Task")
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
    
    func deleteTasks(at offsets: IndexSet) {
        for offset in offsets {
            // find this task in our fetch request
            let task = tasks[offset]

            // delete it from the context
            moc.delete(task)
        }

        // save the context
        try? moc.save()
    }
    
}
  

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
