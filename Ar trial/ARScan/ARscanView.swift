//
//  ARscanView.swift
//  Ar trial
//
//  Created by niudan on 2023/3/16.
//

import SwiftUI
import RealityKit
import Combine

//MARK: ARscanView
/// AR part View
struct ARscanView:View{
    
    
    //MARK: parameters
    @StateObject var ARappARpart:ARappARpartmodel=ARappARpartmodel()
    @EnvironmentObject var Usermodel:Appusermodel
    /// Circuit mode when AR part starts
    let startmode:scanmode?
    /// The circuit mode to update to
    @State var updatemode:scanmode?
    /// Circuit mode of extra view
    @State var extraviewmode:scanmode
    /// Show mode information alert
    @State var showmodeinformation:Bool=false
    @State var showcircuitimage:Bool=false
    @StateObject var Sequencemodel:Sequencegeneratormodel=Sequencegeneratormodel()
    @StateObject var Proportionalmodel:Proportionalcircuitmodel=Proportionalcircuitmodel()
    

    //MARK: body
    var body: some View{
        GeometryReader{geometry in
            let size=geometry.size
            ZStack {
                //Main AR View
                ARViewContainer(
                    startmode: startmode,
                    appmodel: ARappARpart,
                    Sequencemodel: Sequencemodel,
                    updatemode: $updatemode,
                    extraviewmode:$extraviewmode
                )
                    .ignoresSafeArea(.all, edges: .top)
                    .alert(isPresented: $showmodeinformation){
                        ARappARpartmodel.generatemodeinform(mode: extraviewmode)
                    }
                //extra view according to circuit mode
                ARCircuitImageView(
                    appmodel: ARappARpart,
                    extraviewmode: $extraviewmode,
                    ispresent: $showcircuitimage,
                    Geometrysize: size,
                    PresentToggleAnimation:.easeInOut(duration: 0.3)
                )
                modeextraview(geometry: geometry)
                ARUpdatetabView(
                    appmodel: ARappARpart,
                    startmode:startmode!,
                    updatemode: $updatemode,
                    extraviewmode: $extraviewmode,
                    geometry:geometry
                )
                //topleadingbuttons
                if !ARappARpart.Tipconfirmed{
                    ARTipView(appmodel: ARappARpart, geometry: geometry)
                }
                //returnbutton
            }
            .toolbar{ARtoolbarContent(geometrysize: size)}

        }
        .onAppear {
            print("ar Appear")
        }
        .onDisappear {
            print("ar disappear")
        }
    }
}
extension ARscanView{
    /// Extra view that depends on current scanning mode
    private func modeextraview(geometry:GeometryProxy)->some View{
        ZStack{
            switch extraviewmode {
            case .Squarewavegenerator:SquarewaveextraView(outergeometry: geometry)
            case .SquarewaveDRgenerator:SquarewaveDRextraView(outergeometry: geometry)
            case .Secondorder:SecondorderfilterextraView(outergeometry: geometry)
            case .Sequence:SequencegeneratorextraView(appmodel: ARappARpart, Sequencemodel: Sequencemodel)
            case .Proportional:ProportionalextraView(appmodel: ARappARpart, proportionalmodel: Proportionalmodel)
            default:EmptyView()
            }
        }
    }
    
    //MARK: AR toolbar Content
    func ARtoolbarContent(geometrysize:CGSize)->some ToolbarContent{
        Group{
            ToolbarItem(placement:.topBarLeading) {
                HStack{
                    switch extraviewmode {
                    case .Secondorder: Text("")
//                        Button {
//                            ARappARpart.SecondorderfilterAnchor.notifications.playaudio.post()
//                        } label: {
//                            Image(systemName: "music.note")
//                                .font(.system(size: geometrysize.height*0.03, weight: .light))
//
//                        }
                    default:Text("")
                    }

                }
                .font(.title2)
            }

            ToolbarItem(placement:.topBarTrailing) {
                HStack(spacing: .zero){
                    Button {
                        showmodeinformation=true
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.system(size: geometrysize.height*0.03, weight: .light))
                    }
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showcircuitimage.toggle()
                        }
                    } label: {
                        Image(systemName: "photo.circle")
                            .font(.system(size: geometrysize.height*0.03, weight: .light))
                    }
                }
                .font(.title2)
            }
        }
    }

}


//MARK: ARViewContainer
/// The main AR view
struct ARViewContainer: UIViewRepresentable {
    
    /// The AR mode when AR view starts
    let startmode:scanmode?
    @ObservedObject var appmodel:ARappARpartmodel
    @ObservedObject var Sequencemodel:Sequencegeneratormodel
    /// Temporal variable for updating AR mode
    @Binding var updatemode:scanmode?
    /// Temporal variable for updating AR mode
    @Binding var extraviewmode:scanmode
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        guard let scanmode=startmode else {
            return arView
        }
        
        //MARK: add lights
        appmodel.addlight()
        
        
        
        //MARK: add anchors
        appmodel.addanchor(ARview: arView,mode: scanmode)
        
        
        
        //MARK: enable direct gesture(translate,rotate,scale)
        appmodel.enablegesture(arView: arView, mode: scanmode)
        
        
        
        //MARK: define triggers
        appmodel.definetriggeractions(Sequencemodel: Sequencemodel)
        
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let mode=updatemode{
            //remove all anchors
            uiView.scene.anchors.removeAll()
            //add anchor according to update mode
            appmodel.addanchor(ARview: uiView,mode: mode)
            appmodel.enablegesture(arView: uiView,mode: mode)
            appmodel.definetriggeractions(Sequencemodel: Sequencemodel)
            DispatchQueue.main.async {
                Sequencemodel.clear()
                if let updatemode{
                    extraviewmode=updatemode
                }
                updatemode=nil
            }
        }
        
    }
    
}
