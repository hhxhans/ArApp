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
    /// Index of the task in the OnlineTaskModel
    let Taskindex:Int
    @State var showdeletefailalert:Bool=false
    var body: some View {
        let task=OnlineTaskmodel.Tasks[Taskindex]
        let taskremaining=OnlineTaskmodel.Remaining[Taskindex]
        VStack(alignment: .leading){
            if Usermodel.user.authority > 0{
                HStack{
                    Spacer()
                    Button{
                        OnlineTaskmodel.Deletetask(Url: Usermodel.user.simulationurl, taskindex: Taskindex)
                    }label:{
                        Text("Delete task")
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 3))
                    .tint(Color.red)
                }
            }
            Text(task.title).font(.title).foregroundColor(.accentColor)
            Text("\(taskremaining.0)d:\(taskremaining.1)h:\(taskremaining.2)m:\(taskremaining.3)s").font(.title2)
            Text(task.description).font(.title3)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .onDisappear{
            OnlineTaskmodel.Gettasks(Url: Usermodel.user.simulationurl)
        }
        .alert(isPresented: $OnlineTaskmodel.TaskDeletingResponseReceive) {
            Alert(title: OnlineTaskmodel.TaskDeletingSuccess == nil ? Text("") :
                    OnlineTaskmodel.TaskDeletingSuccess! ?
                  Text("Task delete success") :
                    Text("Task delete fail"),
                  dismissButton: .default(Text("OK")){
                if let TaskDeletingSuccess=OnlineTaskmodel.TaskDeletingSuccess{
                    if TaskDeletingSuccess{
                        OnlineTaskmodel.TaskDetaildisplay[Taskindex].toggle()
                    }
                }
                OnlineTaskmodel.TaskDeletingSuccess=nil
            }
            )
        }
    }
}

