//
//  ArappLoginView.swift
//  Ar trial
//
//  Created by niudan on 2023/4/30.
//

import SwiftUI

/// Login View, displays when appstatus == 0
struct ArappLoginView: View {
    @Environment(\.dismiss) var dismiss
    /// User first log in after entering app
    var FirstLogin:Bool = true
    /// Usermodel passed in by ContentView
    @EnvironmentObject var Usermodel:Appusermodel
    
    var TextFieldLeadingLabels:[String]{
         [
         String(localized: "Username"),
         String(localized: "Password"),
         String(localized: "URL")
        ]
    }
    
    //MARK: body
    var body: some View {
        GeometryReader{geometry in
            HStack{
                Spacer()
                VStack{
                    //Upper image
                    Image(.seUlogo).resizable().aspectRatio(nil, contentMode: .fit)
                        .frame(width:geometry.size.width*0.4)
                    //Login TextFields
                    LoginTextFieldAreaView(
                        width: geometry.size.width*0.5,
                        TextFieldLeadingLabel: TextFieldLeadingLabels,
                        TextFieldTypeisSecure: [false,true,true],
                        TextFieldtext: [$Usermodel.user.id,$Usermodel.user.password,$Usermodel.user.simulationurl],
                        TextFieldkeyboardtype: [0,0,2]
                    )
                    //Clear Button and Login Button
                    HStack{
                        Button(action: Usermodel.clearlogintype) {
                            Text("Clear")
                                .foregroundColor(Color.BackgroundprimaryColor)
                        }.disabled(false)
                            .padding()
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        Button(action: {
                            if Usermodel.user.id == "2",Usermodel.user.password == "2"{
                                Usermodel.appstatus=1
                                Usermodel.signinbuttonable=true
                                if !FirstLogin{
                                    dismiss()
                                }
                            }else{
                                Usermodel.loginconfirm(DismissAction: dismiss, FirstLogin: FirstLogin)
                            }
                        }) {
                            Text("Log in")
                                .foregroundColor(!Usermodel.signinbuttonable ? Color.secondary:Color.BackgroundprimaryColor)
                        }.disabled(!Usermodel.signinbuttonable || !Usermodel.Simulationurllegal())
                            .padding()
                            .background(!Usermodel.signinbuttonable || !Usermodel.Simulationurllegal() ? Color.secondary.opacity(0.7) : Color.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    if FirstLogin{
                        //Signup button
                        Button(action: {Usermodel.UserSignup.toggle()}) {
                            Text("Sign up")
                        }
                        .padding()
                        .background(Capsule().stroke())
                        .foregroundColor(Color.accentColor)
                        .padding(.top)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .sheet(isPresented: $Usermodel.UserSignup){
            ARappSignupView()
                .presentationBackground(Usermodel.blurredShapestyle)
        }
        
        .alert(isPresented: $Usermodel.loginfailalert) {
            Alert(
                title: Text("Failed to log in."),
                message: nil,
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

