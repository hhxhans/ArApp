//
//  OnlineTaskGridView.swift
//  Ar trial
//
//  Created by 海心何 on 2023/7/5.
//

import SwiftUI

struct OnlineTaskGridView: View {
    let task:OnlineTask
    let taskremaining:(Int,Int,Int,Int,Bool)
    var Gridwidth:CGFloat?
    var Gridheight:CGFloat?

    var body: some View {
        HStack{
            VStack(alignment: .leading,spacing: .zero){
                HStack{
                    Text(task.title)
                    Image(systemName: "arrow.right.circle")
                }.font(.title)
                    .padding(.horizontal)
                    .foregroundColor(Color.accentColor)
                Divider()
                HStack{
                    if taskremaining.4{
                        Text("Remaining: ").font(.title2)
                        Text("\(taskremaining.0)d:\(taskremaining.1)h:\(taskremaining.2)m").font(.title2)
                    }else{
                        Text("0d:0h:0m Ended").font(.title2)
                            .foregroundColor(taskremaining.4 ? Color.primary : Color.red)
                    }
                }
                .padding(.horizontal)
            }
            .frame(width:Gridwidth,height: Gridheight)
            .background(RoundedRectangle(cornerRadius: 5)
                .stroke(Color.secondary)
            )
            .padding(.horizontal,5)
            Spacer()
        }
    }
}

