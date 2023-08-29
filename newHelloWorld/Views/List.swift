//
//  List.swift
//  newHelloWorld
//
//  Created by leee on 2023/8/28.
//

import SwiftUI

struct ListView: View {
    var restaurantNames = ["Cafe Deadend", "Homei", "Teakha", "Cafe Loisl", "Petite Oyster", "For Kee Restaurant", "Po's Atelier", "Bourke Street Bakery"
                           , "Haigh's Chocolate", "Palomino Espresso", "Upstate", "Traif", "Graham Avenue Meats And Deli", "Waffle & Wolf", "Five Leaves", "Cafe Lore", "Confessional", "Barrafina", "Donostia", "Royal Oak", "CASK Pub and Kitchen"]
    var body: some View {
        List {
            ForEach(restaurantNames, id: \.self) { restaurantName in
                HStack {
                    Image("restaurant")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Item \(restaurantName)")
                }
            }
        }
        .listStyle(.plain)
    }
}


#Preview {
    ListView()
}
