//
//  ARappSignupView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/15.
//

import SwiftUI

/// Singup View, displays after user taps signup Button in LoginView
struct ARappSignupView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var Usermodel:Appusermodel
    @State var username:String=""
    @State var password:String=""
    @State var url:String=""
    let geometry:GeometryProxy
    
    var Signupresulttext:String{
        if let result=Usermodel.Signupsuccess{
            return result ? String(localized: "Sign up success") : String(localized: "Sign up fail")
        }
        return ""
    }
    
    var TextFieldLeadingLabels:[String]{
         [
            String(localized: "Username"),
            String(localized: "Password"),
            String(localized: "URL")
        ]
    }
    
    //MARK: body
    var body: some View {
        let size=geometry.size
        HStack{
            Spacer()
            VStack{
                //View when user pressed signup Button
                if Usermodel.Signingup{
                    if Usermodel.Signupsuccess == nil {
                        ProgressView()
                    }else{
                        Text("Registration").font(.largeTitle).bold()
                        Spacer()
                        Image(systemName: "person.crop.circle")
                            //.resizable().scaledToFit()
                            .foregroundColor(.accentColor)
                            .font(.system(size:size.height*0.1,weight:.light))
                            
                        Text(Signupresulttext)
                            .font(.title)
                            .foregroundColor(Usermodel.Signupsuccess! ? Color.green : Color.red)
                        Spacer()
                    }
                }
                //View when typing in user information
                else{
                    Text("Registration").font(.largeTitle).bold()
                    Spacer()
                    Image(systemName: "person.crop.circle")
                        //.resizable().scaledToFit()
                        .foregroundColor(.accentColor)
                        .font(.system(size:size.height*0.1,weight:.light))
                    LoginTextFieldAreaView(
                        width: size.width/2,
                        TextFieldLeadingLabel: TextFieldLeadingLabels,
                        TextFieldTypeisSecure: [false,true,true],
                        TextFieldtext: [$username,$password,$url],
                        TextFieldkeyboardtype: [0,0,2]
                    )
                    Button{
                        Usermodel.Signup(username: username, password: password, signupurl: url, dismissAction: dismiss)
                    }label: {
                        Text("Confirm")
                            .foregroundColor(.BackgroundprimaryColor)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.accentColor))
                    Spacer()
                    
                }
            }

            Spacer()
        }
    }
}
