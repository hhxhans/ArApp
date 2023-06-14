//
//  ContentView.swift
//  Ar trial
//
//  Created by niudan on 2023/3/8.
//
import SwiftUI

struct ContentView : View {
    @StateObject var Usermodel:Appusermodel=Appusermodel()
    var body: some View {
        ZStack{
            switch Usermodel.appstatus {
            case 0:ArappLoginView()
            case 1:ARappmenuView()

            default: EmptyView()

            }
        }
        .environmentObject(Usermodel)

    }
}



#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
