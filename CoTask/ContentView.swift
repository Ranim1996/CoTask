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

    // MARK: - BODY
    var body: some View {
        NavigationView {
            List {
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
        }}
    
    
    // MARK: - FUNCTIONS
    private func moveTask(source: IndexSet, destination: Int) {
       // tasks.move(fromOffsets: source, toOffset: destination)
    }
}
  
// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
