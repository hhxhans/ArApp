//
//  ARappSignupView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/15.
//

import SwiftUI

/// Singup View, displays after user taps signup Button in LoginView
struct ARappSignupView: View {
    @EnvironmentObject var Usermodel:Appusermodel
    @State var username:String=""
    @State var password:String=""
    @State var url:String=""
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
                            Text(Usermodel.Signupsuccess! ? "Sign up success" : "Sign up fail")
                                .font(.title)
                                .foregroundColor(Usermodel.Signupsuccess! ? Color.green : Color.red)
                        }
                    }
                    //View when typing in user information
                    else{
                        Text("Registration").font(.largeTitle).bold()
                        Spacer()
                        Image(systemName: "person.crop.circle")
                            .resizable().scaledToFit()
                            .frame(width: 100)
                            .foregroundColor(.accentColor)
                        LoginTextFieldAreaView(width: size.width/2, TextFieldLeadingLabel: ["Username","Password","URL"], TextFieldTypeisSecure: [false,true,true], TextFieldtext: [$username,$password,$url], TextFieldkeyboardtype: [0,0,2])
                        Button{
                            Usermodel.Signup(username: username, password: password, signupurl: url)
                        }label: {
                            Text("Confirm")
                                .foregroundColor(.white)
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

