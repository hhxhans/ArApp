//
//  PhotoCacheView.swift
//  Ar trial
//
//  Created by niudan on 2023/6/2.
//

import SwiftUI

struct PhotoCacheView: View {
    @EnvironmentObject var Usermodel:Appusermodel
    var body: some View {
        GeometryReader{
            let size=$0.size
            List {
                LazyVStack{
                    ForEach(Usermodel.PhotoCachekeys) { element in
                        if let uiimage=Usermodel.manager.get(key: element.key){
                            NavigationLink(value: element) {
                                PhotoCacheRow(size: size, uiimage: uiimage, key: element.key, mode: element.mode)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: PhotoCache.self) { PhotoCache in
                Group{
                    if let uiimage=Usermodel.manager.get(key: PhotoCache.key){
                        PhotoCacheDetailView(size: size, uiimage: uiimage, key: PhotoCache.key, mode: PhotoCache.mode)
                    }else{
                        EmptyView()
                    }
                    
                }
            }
        }
        .navigationTitle("Photo Cache")
        .onAppear(perform: Usermodel.Clearcache)

    }
}

struct PhotoCacheRow: View {
    let size:CGSize
    let uiimage:UIImage
    var key:String
    let mode:scanmode
    init(size:CGSize,uiimage:UIImage,key:String,mode:scanmode){
        self.size=size
        self.uiimage=uiimage
        var transferkey:String=key.split(separator: "?").last.map{
            String($0)
        } ?? ""
        transferkey=transferkey.replacingOccurrences(of: "&", with: "\n")
        let lastnindex=transferkey.lastIndex(of: "\n")
        self.key=key
        if lastnindex != nil{
            let endindex=transferkey.endIndex
            transferkey.removeSubrange(lastnindex!..<endindex)
            self.key=transferkey
        }
        self.mode=mode
    }
    var body: some View {
        HStack{
            Image(uiImage: uiimage)
                .resizable().scaledToFit()
                .padding(.leading, 5)
            Text(mode.RawvalueTextString+"\n"+key)
            Spacer()
        }
        .frame(height:size.height*0.4)

    }
}

struct PhotoCacheDetailView:View{
    let size:CGSize
    let uiimage:UIImage
    var key:String
    let mode:scanmode
    init(size:CGSize,uiimage:UIImage,key:String,mode:scanmode){
        self.size=size
        self.uiimage=uiimage
        var transferkey:String=key.split(separator: "?").last.map{
            String($0)
        } ?? ""
        transferkey=transferkey.replacingOccurrences(of: "&", with: "\n")
        let lastnindex=transferkey.lastIndex(of: "\n")
        self.key=key
        if lastnindex != nil{
            let endindex=transferkey.endIndex
//            print(Int(endindex),transferkey.count)
            transferkey.removeSubrange(lastnindex!..<endindex)
            self.key=transferkey
        }
        self.mode=mode
    }
    
    var PhotoCacheDetailViewToolbarContent:some ToolbarContent{
        let shareimage=Image(uiImage: uiimage)
        return Group{
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: shareimage, preview: SharePreview("",image:shareimage)) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                }

            }
        }
    }
    
    var body: some View {
        HStack{
            Image(uiImage: uiimage)
                .resizable().scaledToFit()
                .padding(.leading, 5)
            Text(key)
            Spacer()
        }
        .navigationTitle(mode.RawvalueTextString)
        .toolbar{PhotoCacheDetailViewToolbarContent}
    }
}
