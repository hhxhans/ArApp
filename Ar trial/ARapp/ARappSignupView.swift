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
    
    var Signupresulttext:String{
        if let result=Usermodel.Signupsuccess{
            return result ? "Sign up success" : "Sign up fail"
        }
        return ""
    }
    
    var TextFieldLeadingLabels:[String]{
         [
         "Username",
         "Password",
         "URL"
        ]
    }
    
    //MARK: body
    var body: some View {
        GeometryReader{
            let size=$0.size
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
}

