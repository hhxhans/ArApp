//
//  ARUpdatetabView.swift
//  Ar trial
//
//  Created by niudan on 2023/3/26.
//

import SwiftUI

//MARK: UpdatetabView
/// Update tab
struct ARUpdatetabView:View{
    @ObservedObject var appmodel:ARappARpartmodel
    @EnvironmentObject var Usermodel:Appusermodel
    /// Circuit mode while starting ARView
    let startmode:scanmode
    @Binding var updatemode:scanmode?
    @Binding var extraviewmode:scanmode
    var body: some View{
        GeometryReader{geometry in
            VStack(spacing: .zero){
                Spacer()
                Rectangle().fill(.primary).frame( height: 1).frame(maxWidth: .infinity)
                //Scroll Hstack containing buttons to adjust scanning mode
                ScrollView(.horizontal, showsIndicators: false){
                    ScrollViewReader{proxy in
                        LazyHStack(spacing:.zero){
                            ForEach(scanmode.allCases,id:\.rawValue) { mode in
                                HStack(spacing:.zero){
                                    Rectangle().fill(Color.secondary.opacity(0.5))
                                        .frame(width:1)
                                    Button{
                                        updatemode=mode
                                    }label: {
                                        ZStack{
                                            Text(
                                                mode == extraviewmode ?
                                                mode.RawvalueTextString.appending(String(localized: " (Current)"))
                                                :mode.RawvalueTextString
                                            )
                                                .foregroundColor(mode == extraviewmode ? Color.accentColor:Color.primary)
                                        }.frame(width:geometry.size.width*0.3)
                                    }.controlSize(.large)
                                    .frame(width:geometry.size.width*0.3)
                                    Rectangle().fill(Color.secondary.opacity(0.5))
                                        .frame(width:1)
                                }
                            }
                        }.frame(height:geometry.size.height*Usermodel.Circuitupdatetabheightratio)
                            .onAppear {
                                if let modeindex=appmodel.scanmodeindex[startmode]{
                                    proxy.scrollTo(modeindex+1, anchor: .center)
                                }
                            }
                    }
                }.background(Color.BackgroundprimaryColor.frame(maxWidth: .infinity))
            }
        }
        
    }
}

//struct ARUpdatetabView_Previews: PreviewProvider {
//    static var previews: some View {
//        ARUpdatetabView()
//    }
//}
