//
//  ARappmodel.swift
//  Ar trial
//
//  Created by niudan on 2023/3/21.
//

import SwiftUI
import RealityKit
import CoreData

/// The modes of AR
enum scanmode:String,CaseIterable{
    case free="Free Scanning"
    case Squarewavegenerator="Squarewave generator"
    case SquarewaveDRgenerator="Duty ratio adjustable squarewave generator"
    case Secondorder="Second order filter"
    case Sequence="Sequence generator"
    case Proportional="Proportional Circuit"
}
extension scanmode{
    func RawValuebyLanguage(Language:Bool)->String{
        if Language {
            switch self {
            case .free:return "自由扫描"
            case .Squarewavegenerator:return "矩形波发生器"
            case .SquarewaveDRgenerator:return "占空比可调的矩形波发生器"
            case .Secondorder:return "二阶状态变量滤波器"
            case .Sequence:return "序列发生器"
            case .Proportional:return "加减法电路"
            default:return ""
            }
        }else{
            return self.rawValue
        }
    }
    func Imagename()->String?{
        switch self{
        case .Proportional:return "proportional"
        case .Sequence:return "sequence"
        case .Squarewavegenerator:return "squarewave"
        case .SquarewaveDRgenerator:return "squarewaveDR"
        case .Secondorder:return "secondorderfilter"


        default:return nil
        }
    }
}



//MARK: ARappARpartmodel
/// The model that stores data of the ARscan part
class ARappARpartmodel:ObservableObject{
    
    
    
    //MARK: parameters
    //coredata
    let container: NSPersistentContainer
    @Published var ARapptipEntity: [Tip]
    /// Whether user has confirmed all tips when user first enters ARView
    @Published var Tipconfirmed:Bool
    /// Number of all tips
    let Tipnumber:Int
    //AR part variables
    /// Dictionary used in adding AR anchors
    let scanmodeindex:[scanmode:Int]
    @Published var SquarewaveGeneratorAnchor:Squarewave.Box
    @Published var SquarewaveDRGeneratorAnchor:SquarewaveDR.Box
    @Published var SecondorderfilterAnchor:Secondorderfilter.Box
    @Published var SequencegeneratorAnchor:Sequencegenerator.Box
    @Published var ProportionalAnchor:Proportionalcircuit.Box

    //MARK: initiate
    init() {
        scanmodeindex=[
            .Squarewavegenerator:0,
            .SquarewaveDRgenerator:1,
            .Secondorder:2,
            .Sequence:3,
            .Proportional:4
        ]
        SquarewaveGeneratorAnchor=try! Squarewave.loadBox()
        SquarewaveDRGeneratorAnchor=try! SquarewaveDR.loadBox()
        SecondorderfilterAnchor=try! Secondorderfilter.loadBox()
        SequencegeneratorAnchor=try! Sequencegenerator.loadBox()
        ProportionalAnchor=try! Proportionalcircuit.loadBox()
        container = NSPersistentContainer(name: "ARAppdata")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            }
        }
        Tipconfirmed=true
        ARapptipEntity=[]
        Tipnumber=4
        fetchtipviewed()
        Updatetipstatus()
        print("init")
    }
    deinit {
        print("deinit")
    }
    
    //MARK: functions
    /// Fetch coredata
    func fetchtipviewed() {
        let request = NSFetchRequest<Tip>(entityName: "Tip")
        
        do {
            ARapptipEntity = try container.viewContext.fetch(request)
            if ARapptipEntity.count == 0{
                let tip1=Tip(context: container.viewContext)
                tip1.tipviewed=false
                let tip2=Tip(context: container.viewContext)
                tip2.tipviewed=false
                let tip3=Tip(context: container.viewContext)
                tip3.tipviewed=false
                let tip4=Tip(context: container.viewContext)
                tip4.tipviewed=false
                do {
                    try container.viewContext.save()
                    let request1 = NSFetchRequest<Tip>(entityName: "Tip")
                    ARapptipEntity = try container.viewContext.fetch(request1)
                } catch let error {
                    print("Error saving. \(error)")
                }
            }
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    /// Save coredata
    func SaveTipData() {
        do {
            try container.viewContext.save()
            fetchtipviewed()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    /// Operates when any of the tips is confirmed, if all tips have been confirmed,
    /// set Tipconfirmed true
    func Updatetipstatus()->Void{
        for index in 0..<Tipnumber {
            if !ARapptipEntity[index].tipviewed {
                Tipconfirmed=false
                return 
            }
        }
        Tipconfirmed=true
    }
    /// Add lights to AR anchors
    func addlight()->Void{
        func generatedirectionallight()->DirectionalLight{
            let returnlight:DirectionalLight=DirectionalLight()
            returnlight.look(at: [0,-1000,0], from: [0,1000,0], relativeTo: nil)
            return returnlight
        }
        SquarewaveGeneratorAnchor.addChild(generatedirectionallight())
        SquarewaveDRGeneratorAnchor.addChild(generatedirectionallight())
        SecondorderfilterAnchor.addChild(generatedirectionallight())
        SequencegeneratorAnchor.addChild(generatedirectionallight())
        ProportionalAnchor.addChild(generatedirectionallight())
    }
    
    /// Add anchors to AR scene
    func addanchor(ARview:ARView,mode:scanmode)->Void{
        let Anchors:[HasAnchoring]=[SquarewaveGeneratorAnchor,SquarewaveDRGeneratorAnchor,SecondorderfilterAnchor,SequencegeneratorAnchor,ProportionalAnchor]
        switch mode {
        case .free:
            for index in Anchors.indices {
                ARview.scene.anchors.append(Anchors[index])

            }
        default:ARview.scene.anchors.append(Anchors[scanmodeindex[mode]!])
        }
    }
    
    //MARK: Updatetext
    //proportional update resistance text
    /// Operates when user modifies proportional circuit, updates AR scene
    /// - Parameters:
    ///   - ratext: Value of ra
    ///   - rftext: Value of rf
    ///   - plusresistancetext: Value of all plus side resistors
    ///   - minusresistancetext: Value of all minus side resistors
    func proportionalupdatetext(ratext:String,rftext:String,plusresistancetext:[String],minusresistancetext:[String])->Void{
        var material=SimpleMaterial()
        material.color = .init(tint:.yellow)
        // update ra
        var textentity:Entity=ProportionalAnchor.circuit!.findEntity(named: "ra")!.children[0].children[0]
        var textmodelcomponent:ModelComponent=(textentity.components[ModelComponent.self])!
        textmodelcomponent.materials[0]=material
        textmodelcomponent.mesh = .generateText(ratext.appending("𝛀"), extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02))
        textentity.position=[-0.01,-0.01,0]
        textentity.components.set(textmodelcomponent)
        //update rf
        textentity=ProportionalAnchor.circuit!.findEntity(named: "rf")!.children[0].children[0]
        textmodelcomponent=(textentity.components[ModelComponent.self])!
        textmodelcomponent.materials[0]=material
        textmodelcomponent.mesh = .generateText(rftext.appending("𝛀"), extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02))
        textentity.position=[0,-0.01,0]
        textentity.components.set(textmodelcomponent)
        //update plusinput resistance
        for index in plusresistancetext.indices {
            textentity=ProportionalAnchor.circuit!.findEntity(named: "rp\(index)")!.children[0].children[0]
            textmodelcomponent=(textentity.components[ModelComponent.self])!
            textmodelcomponent.materials[0]=material
            textmodelcomponent.mesh = .generateText(plusresistancetext[index].appending("𝛀"), extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02))
            textentity.position=[0.01,0,0.01]
            textentity.components.set(textmodelcomponent)
        }
        //update minusinput resistance
        for index in minusresistancetext.indices {
            textentity=ProportionalAnchor.circuit!.findEntity(named: "rm\(index)")!.children[0].children[0]
            textmodelcomponent=(textentity.components[ModelComponent.self])!
            textmodelcomponent.materials[0]=material
            textmodelcomponent.mesh = .generateText(minusresistancetext[index].appending("𝛀"), extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02))
            textentity.position=[0.01,0,0.01]
            textentity.components.set(textmodelcomponent)
        }
        
    }
    
    //MARK: Enable gesture
    /// Enable gestures on anchors that temporarily contain no tapping behaviour
    func enablegesture(arView:ARView,mode:scanmode) -> Void {
        switch mode {
        case .Squarewavegenerator:
            let model=SquarewaveGeneratorAnchor.generatorboard!
            model.generateCollisionShapes(recursive: true)
            arView.installGestures([.all], for: model as! (Entity & HasCollision))
        case .SquarewaveDRgenerator:
            let model=SquarewaveDRGeneratorAnchor.generator!
            model.generateCollisionShapes(recursive: true)
            arView.installGestures([.all], for: model as! (Entity & HasCollision))
        case .Secondorder:
            let model=SecondorderfilterAnchor.filter!
            model.generateCollisionShapes(recursive: true)
            arView.installGestures([.all], for: model as! (Entity & HasCollision))
        case .Proportional:
            let model=ProportionalAnchor.circuit!
            model.generateCollisionShapes(recursive: true)
            arView.installGestures([.all], for: model as! (Entity & HasCollision))

        default:break        
        }
    }
    
    
    
    /// Define trigger actions in AR models
    /// - Parameter Sequencemodel: Environment object Sequencemodel
    func definetriggeractions(Sequencemodel:Sequencegeneratormodel)->Void{
        //define 74138 selected notification
        for index1 in SequencegeneratorAnchor.actions.allActions.indices {
            for index2 in Sequencemodel.Select138.indices {
                if SequencegeneratorAnchor.actions.allActions[index1].identifier == "selectY\(index2)" {
                    SequencegeneratorAnchor.actions.allActions[index1].onAction={ [weak self]_  in
                        guard !Sequencemodel.simulating else { return }
                        Sequencemodel.selector138(index2)
//                        for index3 in self!.SequencegeneratorAnchor.notifications.allNotifications.indices {
//                            if self!.SequencegeneratorAnchor.notifications.allNotifications[index3].identifier == "respondY\(index2)"{
//                                self!.SequencegeneratorAnchor.notifications.allNotifications[index3].post()
//                            }
//                        }
                    }
                }
            }
            for index2 in Sequencemodel.Select151.indices {
                //define 74151 D0~D7 selected(set to 0)
                if SequencegeneratorAnchor.actions.allActions[index1].identifier == "selectD\(index2)0" {
                    SequencegeneratorAnchor.actions.allActions[index1].onAction={ [weak self]_ in
                        guard !Sequencemodel.simulating else { return }
                        Sequencemodel.selector151(index2)
//                        for index3 in self!.SequencegeneratorAnchor.notifications.allNotifications.indices {
//                            if self!.SequencegeneratorAnchor.notifications.allNotifications[index3].identifier == "respondD\(index2)0"{
//                                self!.SequencegeneratorAnchor.notifications.allNotifications[index3].post()
//                            }
//                        }
                    }
                }
                //define 74151 D0~D7 selected(set to 1)
                if SequencegeneratorAnchor.actions.allActions[index1].identifier == "selectD\(index2)1" {
                    SequencegeneratorAnchor.actions.allActions[index1].onAction={ [weak self]_ in
                        guard !Sequencemodel.simulating else { return }
                        Sequencemodel.selector151(index2)
//                        for index3 in self!.SequencegeneratorAnchor.notifications.allNotifications.indices {
//                            if self!.SequencegeneratorAnchor.notifications.allNotifications[index3].identifier == "respondD\(index2)1"{
//                                self!.SequencegeneratorAnchor.notifications.allNotifications[index3].post()
//                            }
//                        }
                    }
                }
            }
        }
    }
    
    //MARK: static functions
    
    
    
    
    //MARK: mode information requires editing and changing
    /// Generates mode alert when the toptrailing questionmark.circle button is pressed
    /// - Parameter mode: current scanning mode
    /// - Returns: Alert that includes related text and message
    static func generatemodeinform(mode:scanmode)->Alert{
        var text:Text=Text("")
        var message:Text?=nil
        switch mode {
        case .free:
            text=Text(
                        "This is free scanning mode."
            )
        case .Squarewavegenerator:
            text=Text(
                        "This is a squarewave generator."
            )
        case .SquarewaveDRgenerator:
            text=Text(
                        "This is a duty ratio adjustable squarewave generator."
            )
        case .Secondorder:
            text=Text(
                        "This is a second order filter."
            )
        case .Sequence:
            text=Text(
                        "This is a sequence generator. Tap on 74138 Y0-Y7 and 74151 D0-D7 to set parameters of the generator. Tap the button on the left to see the details of the generator design."
            )
        default:break
        }
        return Alert(title: text,
                     message: message,
                     dismissButton: .default(
                        Text("OK")
                     )
        )
    }
    
}

