//
//  TaskItemView.swift
//  CoTask
//
//  Created by Rawan Abou Dehn on 12/04/2021.
//

import SwiftUI
import CoreData


struct TaskItemView: View {
    // MARK: - PROPERTIES
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>

    let task: Task

    @State var offset = CGSize.zero
    @State var offsetY : CGFloat = 0
    @State var scale : CGFloat = 0.5
    var width: CGFloat = 60.0
    @State private var checked = false

    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geo in
            HStack (spacing : 0){

                NavigationLink(destination: TaskDetailsView(task: task)){
                    VStack {

                        Text(task.title ?? "Unknown Title")
                            .frame(alignment: .leading)
                            .font(.headline)

                        // Priority
                        if(task.priority == "High") {
                            HorizontalLine(color: Color(UIColor(named: "PriorityHigh")!))
//                            HorizontalLine(color: Color(0xDD614A)) // hex (red)
                        }
                        else if(task.priority == "Medium") {
                            HorizontalLine(color: Color(UIColor(named: "PriorityMedium")!))
//                            HorizontalLine(color: Color(0xD6C652)) // (yellow)
                        }
                        else {
                            HorizontalLine(color: Color(UIColor(named: "PriorityLow")!))
//                            HorizontalLine(color: Color(0x73A580)) // (green)
                        }
            
                        
                   } //: VSTACK
                    //.frame(width: geo.size.width, alignment: .leading)

                    //Spacer()

               } //: NAVIGATIONLINK
                //.padding()
                .frame(width: geo.size.width, alignment: .leading)
                
                Spacer(minLength: 18)
                    
                // complete
                ZStack {
                    Image(systemName: "checkmark")
                      .font(.system(size: 20))
                      .scaleEffect(scale)
                }
                .frame(width: width, height: geo.size.height)
                .background(Color(0xDD614A).opacity(0.5))
                .onTapGesture {
                    // mark as done
                    completeTask(taskId: task.id!)
                }
                
                // trash
                ZStack {
                    Image(systemName: "trash")
                        .font(.system(size: 20))
                        .scaleEffect(scale)
                }
                .frame(width: 60, height: geo.size.height)
                .background(Color(0x73A580).opacity(0.5))
                .onTapGesture {
                    // delete
                    deleteTask(taskId: task.id!)
                }
                
             } //: HSTACK
            .offset(self.offset)
            .animation(.spring())
            .gesture(DragGesture()
                .onChanged { gestrue in
                    self.offset.width = gestrue.translation.width
                }
                .onEnded { _ in
                    if self.offset.width < -50 {
                            self.scale = 1
                        self.offset.width = -120
                        self.offsetY = -20
                    } else {
                            self.scale = 0.5
                        self.offset = .zero
                        self.offsetY = 0

                    }
                }
            )
                
        } //: GEOMETRYREADER
    } //: BODY
    
    
    // MARK: - FUNCTIONS
    func deleteTask(taskId: UUID) {
       //deleteData(entityToFetch: "Task")
        
        for task in tasks {
            // find this task in our fetch request
            if(task.id == taskId) {
                // delete it from the context
                moc.delete(task)
            }
        }

        // save the context
        try? moc.save()
    }
    
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
    
    func completeTask(taskId: UUID) {
        for task in tasks {
            // find this task in our fetch request
            if(task.id == taskId) {
                // delete it from the context
                task.isDone = true
            }
        }

        // save the context
        try? moc.save()
    }
}



// MARK: - HORIZAONTAL LINE
struct HorizontalLine: View {
    private var color: Color? = nil
    private var height: CGFloat = 4.0
    private var width: CGFloat = 120.0

    init(color: Color, height: CGFloat = 4.0, width: CGFloat = 120.0) {
        self.color = color
        self.height = height
        self.width = width
    }

    var body: some View {
        HorizontalLineShape().fill(self.color!).frame(minWidth: width, maxWidth: width, minHeight: height, maxHeight: height)
    }
}


struct TaskItemView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let task = Task(context: moc)
        task.title = "Task"
        task.describtion = "Some information"
        task.member = "Ranim"
        task.priority = "High"


        return NavigationView {
            TaskItemView(task: task)
        }
    }
}
