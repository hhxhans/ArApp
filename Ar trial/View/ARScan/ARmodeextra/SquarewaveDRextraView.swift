//
//  SquarewaveDRextraView.swift
//  Ar trial
//
//  Created by niudan on 2023/4/20.
//

import SwiftUI
import Combine


struct SquarewaveDRextraView: View {
    //View properties
    @EnvironmentObject var Usermodel:Appusermodel
    @StateObject var vm = ARsquarewaveDRmodel()
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
                                InputStoptimeTextField(
                                    leadingtext: "stoptime",
                                    Stoptimetext: $vm.stoptimetext,
                                    unittext: "s",
                                    TextfieldWidth: Geometrysize.width/8,
                                    TextFieldKeyboardTyperawValue: 2
                                )
                                InputSlider(leadingtext: "RT:", Slidervalue: $vm.RT, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                                InputSlider(leadingtext: "CT:", Slidervalue: $vm.CT, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "𝛍F")
                                InputSlider(leadingtext: "Uz:", Slidervalue: $vm.Uz, minimumValue: 1, maximumValue: 15, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "V")
                                InputSlider(leadingtext: "RW:", Slidervalue: $vm.RW, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                                InputSlider(leadingtext: "RWRatio:", Slidervalue: $vm.RWRatio, minimumValue: 0, maximumValue: 1, SlidervalueStep: 0.01, ValueLabelDecimalplaces: 2, unittext: "")
                            }
                            InputSlider(leadingtext: "R1:", Slidervalue: $vm.R1, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                            InputSlider(leadingtext: "R2:", Slidervalue: $vm.R2, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                        }.frame(width:Geometrysize.width*0.35)
                            .padding(.horizontal,1)
                        InputConfirmButton(Buttondisable: !vm.Valuelegal()){
                            vm.inputforward(userurl: Usermodel.user.simulationurl)
                            Usermodel.SimulationImagedisplay()
                            if let newkey=vm.Simulationurlstring,
                               Usermodel.manager.get(key: newkey) == nil{
                                let imagekey=Appusermodel.convertsimulationstring(key:vm.Simulationurlstringwithparamater ?? "",mode: .SquarewaveDRgenerator)
                                Usermodel.downloadImage(
                                    Imageurl: newkey,
                                    imagekey: imagekey,
                                    mode: .SquarewaveDRgenerator
                                )
                            }
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
                        )                    //.frame(maxWidth: geometry.size.width*0.9)
                        .gesture(AsyncImageDraggesture(vm: vm))
                }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)

                
            }

        }
        .offset(y:-(outergeometry?.size.height ?? 0)*Usermodel.Circuitupdatetabheightratio)
        .onReceive(Usermodel.Timereveryonesecond, perform: Usermodel.SimulationImageRefreshCountdown)
        
    }
}



struct SquarewaveDRextraView_Previews: PreviewProvider {
    static var previews: some View {
        SquarewaveDRextraView()
    }
}
