//
//  RestaurantListView_Previews.swift
//  newHelloWorld
//
//  Created by leee on 2023/8/28.
//

import SwiftUI

#Preview {
    RestaurantListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

struct RestaurantListView: View {
    @State private var showNewRestaurant = false
    @State private var searchText = ""
    @State private var showWalkthrough = false
    
    @AppStorage("hasViewedWalkthrough") var hasViewedWalkthrough: Bool = false
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        entity: Restaurant.entity(),
        sortDescriptors: []
    )
    var restaurants: FetchedResults<Restaurant>
    
    
    private func deleteRecord(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = restaurants[index]
            context.delete(itemToDelete)
        }
        DispatchQueue.main.async {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    var body: some View {
        NavigationView{
            List {
                if restaurants.count == 0 {
                    Image("emptydata")
                        .resizable()
                        .scaledToFit()
                }else{
                    ForEach(restaurants.indices, id: \.self) { index in
                        ZStack(alignment: .leading) {
                            NavigationLink(destination:RestaurantDetailView(restaurant: restaurants[index])) {
                                EmptyView()
                            }
                            .opacity(0)
                            ListItemView(restaurant: restaurants[index])
                        }
                    }
                    .onDelete(perform: deleteRecord)
                    .swipeActions(edge: .leading, allowsFullSwipe: false, content: {
                        Button {
                        } label: {
                            Image(systemName: "heart")
                        }
                        .tint(.green)
                        Button {
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .tint(.orange)
                    })
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("FoodPin")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                Button(action: {
                    self.showNewRestaurant = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .accentColor(.primary)
        .sheet(isPresented: $showNewRestaurant) {
            NewRestaurantView()
        }
        .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always), prompt: "Search restaurants...")
//        {
//            Text("Thai").searchCompletion("Thai")
//            Text("Cafe").searchCompletion("Cafe")
//            Text("Test").searchCompletion("Test")
//        }
        .onChange(of: searchText) { searchText in
            let namePredicate = searchText.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[c] %@", searchText)
            let locationPredicate = searchText.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "location CONTAINS[c] %@", searchText)
            restaurants.nsPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [namePredicate,locationPredicate])
        }
        .sheet(isPresented: $showWalkthrough) {
            TutorialView()
        }
        .onAppear(){
            showWalkthrough = hasViewedWalkthrough ? false : true
        }
    }
}

struct ListItemView: View {
    @State private var showOptions = false
    @State private var showError = false
    
    @ObservedObject var restaurant:Restaurant
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageData = restaurant.image {
                Image(uiImage: UIImage(data: imageData) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200,alignment:.center)
                    .cornerRadius(20)
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(restaurant.name)
                        .font(.system(.title2, design: .rounded))
                    Text(restaurant.type)
                        .font(.system(.body, design: .rounded))
                    Text(restaurant.location)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.leading,20)
                Spacer()
                if restaurant.isFavorite{
                    //                    Spacer()
                    Image(systemName: "heart.fill")
                        .foregroundColor(.yellow)
                }
                Image(systemName: "chevron.right")
                    .padding(.trailing,20)
                
            }
        }
        .contextMenu {
            Button(action: {
                self.showError.toggle()
            }) {
                HStack {
                    Text("Reserve a table")
                    Image(systemName: "phone")
                }
            }
            Button(action: {
                self.restaurant.isFavorite.toggle()
            }) {
                HStack {
                    Text(restaurant.isFavorite ? "Remove from favorites" : "Mark as favorite")
                    Image(systemName: "heart")
                }
            }
            Button(action: {
                self.showOptions.toggle()
            }) {
                HStack {
                    Text("Share")
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        //        .onTapGesture {
        //            showOptions.toggle()
        //            print(showOptions)
        //        }
        //        .actionSheet(isPresented: $showOptions) {
        //            ActionSheet(title: Text("What do you want to do?"),
        //                        message: nil,
        //                        buttons: [
        //                            .default(Text("Reserve a table")) {
        //                                self.showError.toggle()
        //                            },
        //                            .default(Text("Mark as favorite")) {
        //                                self.restaurant.isFavorite.toggle()
        //                            },
        //                            .cancel()
        //                        ])
        //        }
        .sheet(isPresented: $showOptions) {
            let defaultText = "Just checking in at \(restaurant.name)"
            if let imageData:Data = restaurant.image ,
               let imageToShare = UIImage(data: imageData) {
                ActivityView(activityItems: [defaultText, imageToShare])
            } else {
                ActivityView(activityItems: [defaultText])
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Not yet available"),
                  message: Text("Sorry, this feature is not available yet. Pleaseretry later."),
                  primaryButton:.default(Text("OK")),
                  secondaryButton: .cancel())
        }
    }
}
