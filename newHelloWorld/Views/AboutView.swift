//
//  About.swift
//  newHelloWorld
//
//  Created by leee on 2023/8/29.
//

import SwiftUI

struct AboutView: View {
    
    @State private var link: WebLink?
    
    enum WebLink: String,Identifiable {
        case rateUs = "https://www.apple.com/ios/app-store"
        case feedback = "https://www.appcoda.com/contact"
        case twitter = "https://www.twitter.com/appcodamobile"
        case facebook = "https://www.facebook.com/appcodamobile"
        case instagram = "https://www.instagram.com/appcodadotcom"
        
        var id: UUID {
            UUID()
        }
    }
    
    var body: some View {
        NavigationView{
            List{
                Image("about")
                    .resizable()
                    .scaledToFit()
                Section{
                    Link(destination: URL(string: WebLink.rateUs.rawValue)!, label: {
                        Label(String(localized: "Rate us on App Store", comment: "Rate us on App Store"),image: "store")
                            .foregroundColor(.primary)
                    })
                    Label(String(localized: "Tell us your feedback", comment: "Tell us your feedback"),image: "chat")
                        .onTapGesture {
                            link = .feedback
                        }
                }
                Section {
                    Label(String(localized: "Twitter", comment: "Twitter"), image: "twitter")
                        .onTapGesture {
                            link = .twitter
                        }
                    Label(String(localized: "Facebook", comment: "Facebook"), image: "facebook")
                        .onTapGesture {
                            link = .facebook
                        }
                    Label(String(localized: "Instagram", comment: "Instagram"), image: "instagram")
                        .onTapGesture {
                            link = .instagram
                        }
                }
                
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(/*@START_MENU_TOKEN@*/.automatic/*@END_MENU_TOKEN@*/)
            .sheet(item: $link) { item in
                if let url = URL(string: item.rawValue) {
                    SafariView(url: url)
                }
            }
        }
    }
}

#Preview {
    AboutView()
}
