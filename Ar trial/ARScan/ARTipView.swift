//
//  ARTipView.swift
//  Ar trial
//
//  Created by niudan on 2023/4/10.
//

import SwiftUI
import RealityKit

/// Tips when first entering ARView
struct ARTipView: View {
    @ObservedObject var appmodel:ARappARpartmodel
    @EnvironmentObject var Usermodel:Appusermodel

    var body: some View {
        ZStack{
            Color.gray.ignoresSafeArea(.all)
            if !appmodel.ARapptipEntity[0].tipviewed {
                topleadingtoolbar
            }
            if !appmodel.ARapptipEntity[1].tipviewed {
                simulationtip
            }
        }.frame(maxWidth: .infinity,maxHeight: .infinity)
    }
}

extension ARTipView{
    var topleadingtoolbar:some View{
        GeometryReader{geometry in
            ZStack{
                VStack(spacing:.zero){
                    Text("Press the info icon to see information about current circuit, press the image icon to display the circuit diagram.")
                    Button {
                        appmodel.ARapptipEntity[0].tipviewed=true
                        appmodel.SaveTipData()
                        appmodel.Updatetipstatus()
                    } label: {
                        Text("OK").foregroundColor(.accentColor)
                    }
                }.frame(width: geometry.size.width/4)
                .background(RoundedRectangle(cornerRadius: 2).fill(Color.white.opacity(0.8)))
            }.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
        }
        
    }
    var simulationtip:some View{
        GeometryReader{geometry in
            ZStack{
                VStack(spacing:.zero){
                    Text("This is the simulation area, please ensure the parameters are proper.")
                    Button {
                        appmodel.ARapptipEntity[1].tipviewed=true
                        appmodel.SaveTipData()
                        appmodel.Updatetipstatus()
                    }label: {
                        Text("OK").foregroundColor(.accentColor)
                    }
                }.frame(width:geometry.size.width/4)
                .background(RoundedRectangle(cornerRadius: 2).fill(Color.white.opacity(0.8)))
            }.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottomTrailing)
        }
        
    }
}
