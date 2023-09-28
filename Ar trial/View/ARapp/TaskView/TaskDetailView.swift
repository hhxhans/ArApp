//
//  TaskDetailView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/14.
//

import SwiftUI

/// Details of a task
struct TaskDetailView: View {
    @ObservedObject var OnlineTaskmodel:OnlineTaskModel
    @EnvironmentObject var Usermodel:Appusermodel
    let task:OnlineTask
    @State var showdeletefailalert:Bool=false
    @State var taskdeleted:Bool=false
    var body: some View {
        let taskremaining=OnlineTaskmodel.TaskRemaining(task: task,currentdate:Date())
        VStack(alignment: .leading){
            if Usermodel.user.authority > 0{
                HStack{
                    Spacer()
                    Button{
                        OnlineTaskmodel.Deletetask(Url: Usermodel.user.simulationurl, task: task)
                    }label:{
                        Text("Delete task")
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 3))
                    .tint(Color.red)
                    .disabled(taskdeleted)
                }
            }
            Text(task.title).font(.title).foregroundColor(.accentColor)
            Text("\(taskremaining.0)d:\(taskremaining.1)h:\(taskremaining.2)m:\(taskremaining.3)s").font(.title2)
            Text(task.description).font(.title3)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .alert(isPresented: $OnlineTaskmodel.TaskDeletingResponseReceive) {
            Alert(
                title: OnlineTaskmodel.TaskDeletingSuccess == nil ? Text("") :
                    OnlineTaskmodel.TaskDeletingSuccess! ?
                  Text("Task delete success") :
                    Text("Task delete fail"),
                dismissButton: .default(Text("OK")){
                    if let TaskDeletingSuccess=OnlineTaskmodel.TaskDeletingSuccess{
                        taskdeleted=TaskDeletingSuccess
                        Usermodel.path.removeLast()
                    }
                    OnlineTaskmodel.TaskDeletingSuccess=nil
                }
            )
        }
    }
}

