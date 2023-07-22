//
//  ARMenuView.swift
//  Ar trial
//
//  Created by niudan on 2023/3/20.
//

import SwiftUI

//MARK: Appmenuview
/// App menu
struct ARappmenuView: View {
    @EnvironmentObject var Usermodel:Appusermodel
    @StateObject var ARappMaterialpart:ARappMaterialpartmodel=ARappMaterialpartmodel()
    @State var Appcurrentfunction:AppFunction?
    @State var presentUserDetail:Bool=false
    let menusplitview:Bool=false
    
    
    // MARK: body
    var body: some View {
        
        //Menu SplitView
        NavigationSplitView {
            NavigationSplitViewsidebar
        } detail: {
            NavigationSplitViewdetail
        }
        .sheet(isPresented: $presentUserDetail){
            ARappUserDetailView(AppFunction: $Appcurrentfunction)
                .presentationBackground(Usermodel.blurredShapestyle)
        }
        .onChange(of: Usermodel.path) {
            print($0,$1)
        }
        
        //Menu StackView
        /*
        NavigationStack(path: $Usermodel.path) {
            HStack(alignment: .bottom){
                ForEach(AppFunction.allCases, id:\.rawValue) { function in
                    NavigationLink(value: function) {
                        AppFunctionLabel(function: function)
                    }
                }
            }
            .navigationDestination(for: AppFunction.self) { function in
                switch function{
                case .AR: ARscanView(startmode:.free,extraviewmode: .free)
                case .OnlineTask: OnlineTaskView()
                case .PhotoCache: PhotoCacheView()
                default: EmptyView()
                }
            }
        }
         */
    }
}

extension ARappmenuView{
    
    // MARK: Toolbar Content
    /// ToolbarContent for Menu
    var MenutoolbarContent:some ToolbarContent{
        Group{
            //Trailing picker to switch between two servers
//            ToolbarItemGroup(placement: .topBarTrailing) {
//                Picker(selection: $Usermodel.user.simulationurl){
//                    ForEach(Usermodel.Urladdress.indices,id:\.self){index in
//                        Image(systemName: "\(index).circle")
//                            .foregroundColor(Color.accentColor)
//                            .tag(Usermodel.Urladdress[index])
//                    }
//                } label: {
//                    Image(systemName: "network")
//                        .foregroundColor(Color.accentColor)
//                }
//                .pickerStyle(.menu)
//                .padding(.trailing, 5)
//
//            }
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    presentUserDetail.toggle()
                }, label: {
                    Image(systemName: "person.circle")
                        .font(.title2)
                        .fontWeight(.light)
                })
            }
        }
    }
    
    // MARK: NavigationSplitView sidebar
    private var NavigationSplitViewsidebar:some View{
        List(AppFunction.allCases, selection: $Appcurrentfunction) { function in
            NavigationLink(value: function) {
                Label(function.MenuLabelString, systemImage: function.MenuLabelSystemImagename)
            }
        }
        .toolbar{MenutoolbarContent}
        .navigationTitle("Menu")
    }
    
    // MARK: NavigationSplitView detail
    private var NavigationSplitViewdetail:some View{
        NavigationStack(path:$Usermodel.path){
            if let Appcurrentfunction{
                switch Appcurrentfunction{
                case .AR: ARscanView(startmode:.free,extraviewmode: .free)
                case .OnlineTask: OnlineTaskView()
                case .PhotoCache: PhotoCacheView()
                default: EmptyView()
                }
            }else{
                EmptyView()
            }

        }
    }

    
    //MARK: AR section definition
    /// Navigationlinks to all ARscan views
    private var Scansection:some View{
        Section(header: Text("ARscan").font(.title)) {
            ForEach(scanmode.allCases,id:\.rawValue){mode in
                NavigationLink(destination: ARscanView(startmode:mode,extraviewmode: mode)) {
                    Text(mode.rawValue)
                        .font(.title2)
                }

            }
        }
    }
    
    
    
    //MARK: Material section definition
    /// Navigationlinks to all Material views
    private var Materialsection:some View{
        Section(header: Text("Material").font(.title)) {
            ForEach(ARappMaterialpart.Material.indices,id:\.self) { index in
                NavigationLink(destination: ARappMaterialview(chapter: index, appmodel: ARappMaterialpart)) {
                    Text("Ch\(index)").font(.title2).bold()
                    if ARappMaterialpart.chapterviewed[index]{
                        Text("(last viewing:page\(ARappMaterialpart.imageprogress[index]))").font(.title3)
                    }
                }
                // Set image progress and chapter viewed from AppStorage and coredata
                .onAppear {
                    
                    if let object=UserDefaults.standard.object(forKey: "chapterprogress\(index)") {
                        ARappMaterialpart.imageprogress[index]=object as! Int
                    }
                    for index in ARappMaterialpart.chapterviewed.indices {
                        ARappMaterialpart.chapterviewed[index]=ARappMaterialpart.ARappchapterEntity[index].chapterviewed
                    }
                }
            }
        }
        
    }
    
    @ViewBuilder
    func AppFunctionLabel(function:AppFunction)->some View{
        VStack{
            Image(systemName: function.MenuLabelSystemImagename)
            Text(function.MenuLabelString)
        }
        .font(.title)
    }
    
    
}


struct ARappView_Previews: PreviewProvider {
    static var previews: some View {
        ARappmenuView()
            .environmentObject(Appusermodel())
    }
}
