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
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geo in
            HStack (spacing : 0){
                NavigationLink(destination: TaskDetailsView(task: task)){
                    VStack {

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
                    
                    Spacer()

               } //: NAVIGATIONLINK
                .padding()
                    .frame(width : geo.size.width, alignment: .leading)
                Spacer(minLength: 15)
                    
                // trash
                ZStack {
                    Image(systemName: "checkmark")
                      .font(.system(size: 20))
                      .scaleEffect(scale)
                }
                .frame(width: width, height: geo.size.height)
                .background(Color.purple.opacity(0.15))
                .onTapGesture {
                    // mark as done
                    completeTask(taskId: task.id!)
                }
                
                // complete
                ZStack {
                    Image(systemName: "trash")
                        .font(.system(size: 20))
                }
                .frame(width: 60, height: geo.size.height)
                .background(Color.red.opacity(0.15))
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

enum Period: String, CaseIterable {
    case today = "Today"
    case upcoming = "Upcoming"
    
    static func withLabel(_ label: String) -> Period? {
        return self.allCases.first{ "\($0)" == label }
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
