//
//  ARappMaterialpartmodel.swift
//  Ar trial
//
//  Created by 何海心 on 2023/6/15.
//

import SwiftUI
import CoreData

//MARK: ARappMaterialpartmodel



/// The model that stores data of the ARscan part
class ARappMaterialpartmodel:ObservableObject{
    //MARK: parameters
    //coredata
    let container: NSPersistentContainer
    @Published var ARappchapterEntity: [Chapter]
    //Material part data
    /// Progress of all chapters
    @Published var imageprogress:[Int]
    /// Whether each chapter is viewed
    @Published var chapterviewed:[Bool]
    /// Dictionaries of chapter images
    @Published var Material:[[([Image],Int)]]
    
    //MARK: initiate
    init() {
        
        imageprogress=[0,0]
        chapterviewed=[false,false]
        Material=[]
        let chapterlength:[Int]=[47]
        var Materialimages:[[([Image],Int)]]=[]
        for index1 in chapterlength.indices {
            var chapterimages:[([Image],Int)] = []
            for index2 in 0..<chapterlength[index1] {
                chapterimages.append(([Image("幻灯片"+String(index2+1))],0))
            }
            Materialimages.append(chapterimages)
        }
        Material=Materialimages
        
//        Material=[[([Image("SEUlogo_dark")],0),([Image("SEUlogo"),Image("SEUlogo_dark")],0)],[([Image("SEUlogo_dark"),Image("SEUlogo")],0),([Image("SEUlogo"),Image("SEUlogo_dark")],0)]]
        container = NSPersistentContainer(name: "ARAppdata")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            }
        }
        ARappchapterEntity=[]
        fetchchapterviewed()
    }
    
    /// Fetch coredata
    func fetchchapterviewed() {
        let request = NSFetchRequest<Chapter>(entityName: "Chapter")
        
        do {
            ARappchapterEntity = try container.viewContext.fetch(request)
            if ARappchapterEntity.count == 0{
                let chapter1=Chapter(context: container.viewContext)
                chapter1.chapterviewed=false
                let chapter2=Chapter(context: container.viewContext)
                chapter2.chapterviewed=false
                do {
                    try container.viewContext.save()
                    let request1 = NSFetchRequest<Chapter>(entityName: "Chapter")
                    ARappchapterEntity = try container.viewContext.fetch(request1)
                } catch let error {
                    print("Error saving. \(error)")
                }
            }
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    /// Save coredata
    func SaveMaterialData() {
        do {
            try container.viewContext.save()
            fetchchapterviewed()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    /// Toggle chapter viewed boolean, save tap record to coredata
    /// - Parameter index: Material chapter index
    func chaptertapped(index:Int)->Void{
        chapterviewed[index]=true
        ARappchapterEntity[index].chapterviewed=true
        SaveMaterialData()
    }
    
    ///  Material go forward
    /// - Parameter chapter: Material chapter index
    func chapterforward(chapter:Int)->Void{
        if Material[chapter][imageprogress[chapter]].1 < Material[chapter][imageprogress[chapter]].0.count-1  {
            Material[chapter][imageprogress[chapter]].1 += 1
        }else if imageprogress[chapter] != Material[chapter].count-1{
            imageprogress[chapter] += 1
        }
    }
    
    ///  Material go backward
    /// - Parameter chapter: Material chapter index
    func chapterbackward(chapter:Int)->Void{
        switch (Material[chapter][imageprogress[chapter]].1 == 0,imageprogress[chapter] == 0) {
        case (true,false):
            imageprogress[chapter] -= 1
        case (false,_):Material[chapter][imageprogress[chapter]].1 -= 1
        case (true,true):break
        }
    }
    
    /// Scroll to top/bottom/image
    /// - Parameters:
    ///   - proxy: scrollview proxy
    ///   - chapter: Material chapter index
    ///   - value: scroll to position
    func scrolltoindex(proxy:ScrollViewProxy,chapter:Int,value:Int)->Void{
        withAnimation(.spring()) {
            if value==0 {
                proxy.scrollTo(value, anchor: .top)
            }else if value==Material[chapter].count-1{
                proxy.scrollTo(value, anchor: .bottom)
            }else{
                proxy.scrollTo(value, anchor: .center)
            }
        }
    }
    
    /// Scroll to top/bottom/image when the view appears
    /// - Parameters:
    ///   - proxy: scrollview proxy
    ///   - chapter: Material chapter index
    func appearscrolltoindex(proxy:ScrollViewProxy,chapter:Int)->Void{
        withAnimation(.spring()) {
            if imageprogress[chapter]==0 {
                proxy.scrollTo(0, anchor: .top)
            }else if imageprogress[chapter]==Material[chapter].count-1{
                proxy.scrollTo(Material[chapter].count-1, anchor: .bottom)
            }else{
                proxy.scrollTo(imageprogress[chapter], anchor: .center)
            }
        }
    }
    
}

