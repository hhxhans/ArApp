//
//  VoltageregulatorextraView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/24.
//

import SwiftUI

struct VoltageregulatorextraView: View {
    //View properties
    @EnvironmentObject var Usermodel:Appusermodel
    @StateObject var vm = ARvoltageregulatormodel()
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
                                InputSlider(leadingtext: "R2:", Slidervalue: $vm.R2, minimumValue: 0.1, maximumValue: 1, SlidervalueStep: 0.01, ValueLabelDecimalplaces: 2, unittext: "k𝛀")
                                InputSlider(leadingtext: "UD1:", Slidervalue: $vm.UD1, minimumValue: 1, maximumValue: 5, SlidervalueStep: 0.1, ValueLabelDecimalplaces: 1, unittext: "V")
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

