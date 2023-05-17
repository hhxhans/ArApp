//
//  ArappLoginView.swift
//  Ar trial
//
//  Created by niudan on 2023/4/30.
//

import SwiftUI
import UIKit
import RealityKit

struct ArappLoginView: View {
    @EnvironmentObject var Usermodel:Appusermodel
    var body: some View {
        GeometryReader{geometry in
            HStack{
                Spacer()
                VStack{
                    Image("SEUlogo").resizable().aspectRatio(nil, contentMode: .fit)
                        .frame(width:geometry.size.width*0.4)
                    LoginTextFieldAreaView(width: geometry.size.width*0.5, TextFieldLeadingLabel: ["Username","Password","URL"], TextFieldTypeisSecure: [false,true,true], TextFieldtext: [$Usermodel.user.id,$Usermodel.user.password,$Usermodel.user.simulationurl], TextFieldkeyboardtype: [0,0,2])
                    HStack{
                        Button(action: Usermodel.clearlogintype) {
                            Text("Clear")
                                .foregroundColor(.white)
                        }.disabled(false)
                            .padding()
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 5))

                        Button(action: {
                            Usermodel.loginconfirm()
                        }) {
                            Text("Log in")
                                .foregroundColor(!Usermodel.signinbuttonable ? Color.secondary:Color.white)
                        }.disabled(!Usermodel.signinbuttonable || !Usermodel.Simulationurllegal())
                            .padding()
                            .background(!Usermodel.signinbuttonable || !Usermodel.Simulationurllegal() ? Color.secondary.opacity(0.7) : Color.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    
                    Button(action: {Usermodel.UserSignup.toggle()}) {
                        Text("Sign up")
                    }
                    .padding()
                    .background(Capsule().stroke())
                    .foregroundColor(Color.accentColor)
                    .padding(.top)

                    
                    Spacer()
                }
                Spacer()
            }
            

        }
        .blurredSheet(.init(.ultraThinMaterial), show: $Usermodel.UserSignup){
            
        }content: {
            ARappSignupView()
        }
        
        .alert(isPresented: $Usermodel.loginfailalert) {
            Alert(title: Text("Failed to log in."), message: nil, dismissButton: .default(Text("OK")))
        }
    }
}

struct ArappLoginView_Previews: PreviewProvider {
    static var previews: some View {
        ArappLoginView()
    }
}