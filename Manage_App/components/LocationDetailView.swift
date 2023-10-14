import SwiftUI

struct LocationDetailView: View {
    let place: Place
    
    @EnvironmentObject private var model: PlaceModel
    let userDefaults = UserDefaults.standard
    
    @Environment(\.presentationMode) var presentationMode
    @State private var image: Image? = nil
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionSheet = false
    @State private var shouldPresentCamera = false
    
    @State var isEditedPlace = false
    @State var namePlaceEdited = ""
    
    private func populateItem(ownerId: String, locationID: String) async {
        do {
            try await model.getItemsByLocation(ownerID: ownerId, locationID: locationID)
        } catch {
            print(error)
        }
    }
    
    private func updatePlace(imageBase64: String) async {
        do {
            try await model.updateLocation(placeRequest: PlaceRequest(_id: place._id, namelocation: namePlaceEdited, imagebase64: imageBase64))
            
        } catch {
            print(error)
        }
    }
    
    private func deletePlace(placeID: String) async {
        do {
            try await model.deleteLocation(placeID: placeID)
            
            //            dismiss()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print(error)
        }
    }
    
    private func deleteItem(itemID: String) async {
        do {
            try await model.deleteItem(itemID: itemID)
        } catch {
            print(error)
        }
    }
    
    func convertImageToBase64String (img: UIImage?) -> String {
        guard let image = img else {
            return ""
        }
        let scaledImage = image.resize(tragetSize: CGSize(width: 300, height: 300))
        
        let imageData = scaledImage.jpegData(compressionQuality: 0.7)
        return imageData?.base64EncodedString() ?? ""
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView {
                        ZStack {
                            // Asynchronously load and display the image from the URL
                            if image == nil {
                                AsyncImageHack(url: URL(string: place.imagelocation)) { view in
                                    
                                    view.image?
                                        .resizable() // Apply the `resizable()` modifier here
                                       .frame(width: 150, height: 150)
                                       .aspectRatio(contentMode: .fit)
                               }
  //                              placeholder: {
//                                    ProgressView()
//                                }
                            } else {
                                image!
                                    .resizable() // Apply the `resizable()` modifier here
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                            if isEditedPlace {
                                Button {
                                    shouldPresentActionSheet = true
                                } label: {
                                    Image(systemName: "camera.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                }.sheet(isPresented: $shouldPresentImagePicker) {
                                    SUImagePickerView(sourceType: shouldPresentCamera ? .camera : .photoLibrary, image: $image, isPresented: $shouldPresentImagePicker)
                                }
                                .actionSheet(isPresented: $shouldPresentActionSheet) {
                                    ActionSheet(title: Text("Take Image"), message: Text("Choose image source"), buttons: [
                                        .default(Text("Camera"), action: {
                                            shouldPresentImagePicker = true
                                            shouldPresentCamera = true
                                        }),
                                        .default(Text("Photo Library"), action: {
                                            shouldPresentImagePicker = true
                                            shouldPresentCamera = false
                                        }),
                                        .cancel()
                                    ])
                                }
                            }
                        }
                        
                        if !isEditedPlace {
                            Text(namePlaceEdited)
                                .font(.title)
                        } else {
                            TextField(namePlaceEdited, text: $namePlaceEdited)
                                .font(.title)
                                .multilineTextAlignment(.center)
                        }
                        
                        if model.items.isEmpty {
                            Text("No items").accessibilityLabel("noOrdersText")
                        } else {
                            LazyVStack(alignment: .leading) {
                                ForEach(model.items, id: \.self) { item in
                                    NavigationLink(destination: ItemDetailView(itemDetail: item)) {
                                        HStack {
                                            AsyncImageHack(url: URL(string: item.imageitem ?? "")) { view in
                                                view.image?
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 100, height: 80)
                                                    .cornerRadius(10)
                                            }
//                                        placeholder: {
//                                            ProgressView()
//                                        }
                                            Text(item.nameItem ?? "")
                                                .bold()
                                                .frame(maxWidth: .infinity)
                                            Spacer()
                                            
                                            VStack {
                                                Button {
                                                    Task {
                                                        await deleteItem(itemID: item._id)
                                                    }
                                                } label: {
                                                    Image(systemName: "trash")
                                                        .foregroundColor(.white)
                                                        .scaledToFill().frame(maxWidth: 80 ,maxHeight: .infinity, alignment: .center)
                                                }
                                            }.background(.red)
                                                .frame(maxWidth: 80,maxHeight: .infinity, alignment: .trailing)
                                                .border(Color.red, width: 1)
                                            
                                        }.frame(maxWidth: .infinity,alignment: .center)
                                    }
                                }
                            }
                        }
                    }.task {
                        await populateItem(ownerId: place.owner, locationID: place._id)
                    }
                    
                }
                .padding()
                
              //  .navigationTitle("Item")
                .toolbar {
                    
                    if isEditedPlace {
                        Button {
                            self.isEditedPlace = !self.isEditedPlace
                            self.image = nil
                            self.namePlaceEdited = place.namelocation
                        } label: {
                            Image(systemName: "xmark.circle")
                        }
                    } else {
                        Button {
                            Task {
                                await deletePlace(placeID: place._id)
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                    Button {
                        if isEditedPlace {
                            Task {
                                let size = CGSize(width: 300, height: 300)
                                let data : UIImage? = image?.getUIImage(newSize: size)
                                let base64 = convertImageToBase64String(img: data)
                                await updatePlace(imageBase64: base64)
                            }
                        }
                        self.isEditedPlace = !self.isEditedPlace
                    } label: {
                        if !isEditedPlace {
                            Image(systemName: "highlighter")
                        } else {
                            Image(systemName: "checkmark.circle")
                        }
                    }
                }
                .onAppear {
                    namePlaceEdited = self.place.namelocation
                }
                
                VStack {
                    Spacer()
                    Spacer()
                    
                    ZStack(alignment: .bottomTrailing) {
                        HStack{
                            Spacer()
                            Button(action: {
                            }){
                                NavigationLink(destination: ItemView(idLocation: place._id)){
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 12,height: 12)
                                        .padding(30)
                                }
                            }
                           
                            .background(Color("g4"))
                            .foregroundColor(.white)
                            .cornerRadius(.infinity).padding()
                        }
                    }
                }
            }
        }
        
    }
}
