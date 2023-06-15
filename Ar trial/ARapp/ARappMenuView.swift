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
    @State var usersheetpresent:Bool=false
    @State var Appcurrentfunction:AppFunction?
    @State var path: NavigationPath=NavigationPath()
    
    
    
    // MARK: body
    var body: some View {
        NavigationSplitView {
            NavigationSplitViewsidebar
        } detail: {
            NavigationSplitViewdetail
        }
        .onChange(of: path) {
            print($1)
        }

//        NavigationView{
//            List{
//                //MARK: ARscan section placement
//                Scansection
//                
//
//               
//                
//                //MARK: Material section placement
//                //Materialsection
//                NavigationLink(destination: PhotoCacheView()) {
//                    Text(Usermodel.Language ? "仿真图像缓存" : "Photo Cache").font(.title2)
//                }
//                NavigationLink(destination: OnlineTaskView()) {
//                    Text(Usermodel.Language ? "任务" : "Tasks").font(.title2)
//                }
//                Button {
//                    Usermodel.logout(FirstLogin: false)
//                    usersheetpresent.toggle()
//                } label: {
//                    Text(Usermodel.Language ? "登出" : "Log out")
//                        .font(.title2)
//                        .padding(5)
//                        .foregroundColor(Color.BackgroundprimaryColor)
//                        .background(Color.red.cornerRadius(3))
//                }
//
//                
//            }
//            .navigationTitle(Usermodel.Language ? "主页" : "Menu")
//            .toolbar{MenutoolbarContent}
//            .fullScreenCover(isPresented: $usersheetpresent) {
//                ArappLoginView(FirstLogin: false)
//            }
//
//        }
    }
}

extension ARappmenuView{
    
    // MARK: Toolbar Content
    /// ToolbarContent for Menu
    var MenutoolbarContent:some ToolbarContent{
        Group{
            //Trailing picker to switch between two servers
            ToolbarItemGroup(placement: .topBarTrailing) {
                Picker(selection: $Usermodel.user.simulationurl){
                    ForEach(Usermodel.Urladdress.indices,id:\.self){index in
                        Image(systemName: "\(index).circle")
                            .foregroundColor(Color.accentColor)
                            .tag(Usermodel.Urladdress[index])
                    }
                } label: {
                    Image(systemName: "network")
                        .foregroundColor(Color.accentColor)
                }
                .pickerStyle(.menu)
                .padding(.trailing, 5)

            }
            ToolbarItem(placement: .bottomBar) {
                Image(systemName: "person.circle")
                    .font(.title2)
                    .fontWeight(.light)
            }
        }
    }
    
    // MARK: NavigationSplitView sidebar
    private var NavigationSplitViewsidebar:some View{
        List(AppFunction.allCases, selection: $Appcurrentfunction) { function in
            NavigationLink(value: function) {
                Label(function.rawValue, systemImage: function.MenuLabelSystemImagename)
            }
        }
        .toolbar{MenutoolbarContent}
        .navigationTitle("Menu")
    }
    
    // MARK: NavigationSplitView detail
    private var NavigationSplitViewdetail:some View{
        NavigationStack(path:$path){
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
    
    
}


struct ARappView_Previews: PreviewProvider {
    static var previews: some View {
        ARappmenuView()
            
    }
}
