//
//  ContentView.swift
//  newHelloWorld
//
//  Created by leee on 2023/8/28.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var selectedTabIndex = 0
    
    var body: some View {
        TabView(selection: $selectedTabIndex,
                content:  {
            RestaurantListView()
                .tabItem { Label("Favorites",systemImage: "tag.fill") }
                .tag(0)
            Text("Discover")
                .tabItem { Label("Discover",systemImage: "wand.and.rays") }
                .tag(1)
            AboutView()
                .tabItem { Label("About",systemImage: "square.stack") }
                .tag(2)
        })
        .accentColor(Color("NavigationBarTitle"))
    }
}

#Preview {
    ContentView()
}

struct LoginView : View{
    let synthesizer = AVSpeechSynthesizer()
    
    func text2speech(text:String) {
        // If you write A in the text2speech function, synthesizer.speak(utterance) is not worked.
        // let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.52
        self.synthesizer.speak(utterance)
    }
    
    var body: some View{
        VStack(spacing:20) {
            
            Button {
                text2speech(text: "hello programming")
                
            } label: {
                Text("Hello Programming")
                    .fontWeight(.bold)
                    .font(.system(.title, design: .rounded))
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.yellow)
            .cornerRadius(20)
            
            Button {
                text2speech(text: "Hello world")
                
            } label: {
                Text("Hello World")
                    .fontWeight(.bold)
                    .font(.system(.title, design: .rounded))
                    .foregroundStyle(.white)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.purple)
            .cornerRadius(20)
            HStack(alignment: .bottom,spacing: 10) {
                Image("user1")
                    .resizable()
                    .scaledToFit()
                Image("user2")
                    .resizable()
                    .scaledToFit()
                Image("user3")
                    .resizable()
                    .scaledToFit()
            }
            .padding(.horizontal,20)
            Text("Need help with coding problems? Register!")
                .foregroundStyle(.white)
            Spacer()
            VSignUpButtonGroup()
            
        }
        .background{
            Image("background")
                .resizable()
                .ignoresSafeArea()
        }
    }
}


struct VSignUpButtonGroup: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var body: some View {
        if verticalSizeClass == .compact {
            HStack {
                Button {
                } label: {
                    Text("Sign Up")
                }
                .frame(width: 200)
                .padding()
                .foregroundColor(.white)
                .background(Color.indigo)
                .cornerRadius(10)
                Button {
                } label: {
                    Text("Log In")
                }
                .frame(width: 200)
                .padding()
                .foregroundColor(.white)
                .background(Color.gray)
                .cornerRadius(10)
            }
        } else {
            VStack {
                Button {
                } label: {
                    Text("Sign Up")
                }
                .frame(width: 200)
                .padding()
                .foregroundColor(.white)
                .background(Color.indigo)
                .cornerRadius(10)
                Button {
                } label: {
                    Text("Log In")
                }
                .frame(width: 200)
                .padding()
                .foregroundColor(.white)
                .background(Color.gray)
                .cornerRadius(10)
            }
        }
        
    }
}
