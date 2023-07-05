//
//  ARappUserDetailView.swift
//  Ar trial
//
//  Created by 海心何 on 2023/7/5.
//

import SwiftUI

struct ARappUserDetailView: View {
    @EnvironmentObject var Usermodel:Appusermodel
    @State var presentUserReLogin:Bool=false
    @Binding var AppFunction:AppFunction?
    var body: some View {
        VStack{
            Text(Usermodel.user.id)
            Button {
                Usermodel.logout(FirstLogin: false)
                AppFunction=nil
                presentUserReLogin.toggle()
            } label: {
                Text("Log out")
                    .font(.title2)
                    .padding(5)
                    .foregroundColor(Color.BackgroundprimaryColor)
                    .background(Color.red.cornerRadius(3))
            }
        }
        .fullScreenCover(isPresented: $presentUserReLogin) {
            ArappLoginView(FirstLogin: false)
        }
    }
}

//#Preview {
//    ARappUserDetailView()
//}
