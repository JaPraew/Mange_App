//
//  Sharewithme.swift
//  Manage_App


import SwiftUI

struct Sharewithme: View {
    
    let userDefaults = UserDefaults.standard
    
    @EnvironmentObject private var model: PlaceModel
    
    func populateShareWithMe() async {
        do {
            let userEmail = userDefaults.string(forKey: "userEmail") ?? ""
            try await model.shareWithMe(shareWithMeReques: ShareWithMeRequest(emailowner: userEmail))
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        VStack {
            Text("Share")
            .font(.title2)
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(model.shareWithMe , id:\.self) { location in
                        NavigationLink(destination: LocationDetailView(place: location)) {
                            HStack {
                                AsyncImage(url: URL(string: location.imagelocation )) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 50)
                                        .cornerRadius(10)
                                }
                            placeholder: {
                                ProgressView()
                            }
                                Text(location.namelocation )
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                Spacer()
                                
                            }.frame(maxWidth: .infinity,alignment: .center)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
                                }
                        }
                    }
                }
            }
        }
            .task {
                await populateShareWithMe()
            }
    }
}

struct Sharewithme_Previews: PreviewProvider {
    static var previews: some View {
        Sharewithme().environmentObject(PlaceModel(webservice: Webservice()))
    }
}
