//
//  OnlineTaskView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/12.
//

import SwiftUI
import Combine

/// View of all Online Tasks
struct OnlineTaskView: View {
    @EnvironmentObject var Usermodel:Appusermodel
    @StateObject var OnlineTaskmodel:OnlineTaskModel=OnlineTaskModel()
    @State var CurrentDateforrefreshingview:Date=Date()
    var columns: [GridItem] { [GridItem(.adaptive(minimum: 200))] }
    //MARK: OnlineTaskViewToolbar
    var OnlineTaskViewToolbar:some ToolbarContent{
        Group{
            ToolbarItem(placement: .topBarTrailing) {
                HStack{
                    if Usermodel.user.authority>0{
                        Button{
                            OnlineTaskmodel.TaskAddingdisplay.toggle()
                        }label:{
                            HStack{
                                Image(systemName:"plus")
                                Text("Add task")
                            }
                        }.padding(.horizontal,2)
                            .background(
                                RoundedRectangle(cornerRadius: 5).stroke(Color.accentColor)
                            )
                    }
                    Button{
                        OnlineTaskmodel.Gettasks(Url: Usermodel.user.simulationurl)
                    } label:{
                        Image(systemName: "arrow.clockwise").font(.title2)
                    }
                }
            }
        }
    }
    
    
    
    //MARK: body
    var body: some View {
        ZStack{
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack{
                    HStack{
                        Text(CurrentDateforrefreshingview.DatetoString("YYYY MMM dd hh:mm:ss")).font(.title)
                        Spacer()
                    }
                    LazyVGrid(columns: columns,spacing: 2) {
                        ForEach(OnlineTaskmodel.Tasks){task in
                            let currentdate=Date()
                            let taskremaining=OnlineTaskmodel.TaskRemaining(task: task,currentdate:currentdate)
                            NavigationLink(value: task) {
                                OnlineTaskGridView(task: task, taskremaining: taskremaining)
                            }
                        }
                    }
                }.padding(.leading,5)
            }
            .navigationDestination(for: OnlineTask.self) { task in
                TaskDetailView(OnlineTaskmodel: OnlineTaskmodel, task:task)
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .navigationTitle("Online Tasks")
        .toolbar{OnlineTaskViewToolbar}
        .sheet(isPresented: $OnlineTaskmodel.TaskAddingdisplay) {
            OnlineTaskAddingView(OnlineTaskmodel: OnlineTaskmodel)
                .presentationDetents([.large,.medium])
                .presentationBackground(Usermodel.blurredShapestyle)
        }
        .onAppear{
            OnlineTaskmodel.Gettasks(Url: Usermodel.user.simulationurl)
        }
        .onReceive(Usermodel.Timereveryonesecond) { date in
            CurrentDateforrefreshingview=Date()
        }
        //.ignoresSafeArea(.all, edges: .top)
    }
    
    
    
}
    
//    @ViewBuilder
//    func ScrollViewHeader()->some View{
//        VStack{
//            HStack{
//                Text(Date().DatetoString("MMM YYYY")).padding(.leading,5)
//                Spacer()
//            }
//            HStack(spacing: .zero){
//                ForEach(Calendar.current.currentWeek) {day in
//                    Spacer()
//                    VStack(spacing:5){
//                        Text(day.string.prefix(3)).font(.system(size: 12))
//                        Text(day.date.DatetoString("dd")).font(.system(size: 16))
//                    }
//                    .foregroundColor(Calendar.current.isDate(day.date, inSameDayAs: currentDay) ? Color.accentColor : .secondary)
//                    .contentShape(Rectangle())
//                    Spacer()
//                }
//            }
//        }
//    }
