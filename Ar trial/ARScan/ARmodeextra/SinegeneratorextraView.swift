//
//  SinegeneratorextraView.swift
//  Ar trial
//
//  Created by 何海心 on 2023/5/18.
//

import SwiftUI

struct SinegeneratorextraView: View {
    //View properties
    @EnvironmentObject var Usermodel:Appusermodel
    @StateObject var vm = ARsinegeneratormodel()
    @State var testonly:CGFloat = 100
    var outergeometry:GeometryProxy?
    

    var body: some View {
        let Geometrysize=outergeometry?.size ?? CGSize()
        Group{
            switch vm.status {
            case .start:
                StartButton(Buttonaction: vm.startforward)
            case .input:
                ZStack{
                    VStack(alignment:.trailing,spacing:.zero){
                        VStack(alignment:.trailing,spacing:.zero){
                            InputupperLabel(backwardButtonaction: vm.inputbackward)
                            Group{
                                InputSlider(leadingtext: "R:", Slidervalue: $vm.R, minimumValue: 1, maximumValue: 100, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                                InputSlider(leadingtext: "C:", Slidervalue: $vm.C, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "𝛍F")
                            }
                        }.frame(width:Geometrysize.width*0.35)
                            .padding(.horizontal,1)
                        InputConfirmButton(Buttondisable: !vm.Valuelegal()){
                            vm.inputforward(userurl: Usermodel.user.simulationurl)
                            Usermodel.SimulationImagedisplay()
                        }
                    }.frame(width:Geometrysize.width*0.35)
                        .background(
                            InputbackgroundView()
                        )
                        .gesture(InputAreaDraggesture(vm:vm))
                        
                }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)
            case .image:
                ZStack{
                    VStack(spacing:.zero){
                        SimulationImageupperLabel(RefreshButtondisable: Usermodel.SimulationimageRefreshDisable, imagezoom: vm.imagezoom, backwardButtonaction: vm.imagebackward) {
                            vm.imagerefresh(userurl: Usermodel.user.simulationurl)
                            Usermodel.SimulationimageRefreshDisable=true
                        } zoomButtonaction: {
                            withAnimation(Animation.spring()) {vm.imagezoom.toggle()}
                        }
                        Divider()
                        if let imageurl=vm.Simulationurl{
                            AsyncImage(url: imageurl) {
                                AsyncImageContent(phase: $0, geometrysize: Geometrysize, vm: vm)
                            }
                        }
                    }.frame(width: Geometrysize.width/2*vm.imagezoomratio)
                        .padding(.horizontal,1)
                        .background(
                            SimulationImagebackgroundView()
                        )
                    //.frame(maxWidth: geometry.size.width*0.9)
                        .gesture(AsyncImageDraggesture(vm: vm))
                }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)

                
            }

        }
        .offset(y:-(outergeometry?.size.height ?? 0)*Usermodel.Circuitupdatetabheightratio)
        .onReceive(Usermodel.Timereveryonesecond, perform: Usermodel.SimulationImageRefreshCountdown)
        
    }
}

