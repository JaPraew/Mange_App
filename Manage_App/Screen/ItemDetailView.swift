//
//  ItemDetailView.swift
//  Manage_App


import SwiftUI

struct ItemDetailView: View {
    let itemDetail : Item
    
    @EnvironmentObject private var model: PlaceModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var image: Image? = nil
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionSheet = false
    @State private var shouldPresentCamera = false
    @State var isEdited = false
    @State var newTitle = ""
    @State var newDescription = ""
    
    @State private var selectedOption = "Move"
    @State private var isPickerVisible = false
        
    let options = ["room 1", "room 2", "room 3"]
        
    private func updateItem(imageBase64: String) async {
        
        do {
            if(newTitle.isEmpty ){
                newTitle = itemDetail.nameItem ?? ""
            }
            if(newDescription.isEmpty ){
                newDescription = itemDetail.descriptionItem ?? ""
            }
            try await model.updateItem(itemRequest: ItemRequest(nameItem: newTitle, imagebase64: imageBase64, imagename: newTitle, descriptionItem: newDescription, idlocation: itemDetail.idlocation ?? "", owner: itemDetail.owner ?? ""), itemID: itemDetail._id)
            
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
        VStack {
            ZStack {
                VStack {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        if image != nil {
                            image?.resizable() // Apply the `resizable()` modifier here
                                .frame(width: 300, height: 300)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.black)
                                .padding(.top, 60)
                                .padding(.bottom, 60)
                        } else {
                            
                            AsyncImage(url: URL(string: itemDetail.imageitem ?? "" )) { image in
                                image
                                    .resizable() // Apply the `resizable()` modifier here
                                    .frame(width: 300, height: 300)
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.black)
                                    .padding(.top, 60)
                                    .padding(.bottom, 60)
                            } placeholder: {
                                ProgressView()
                            }.cornerRadius(10).background(Color.white)
                        }
                    }
                }
                
                HStack {
                    
                    if isEdited {
                        Button {
                            shouldPresentActionSheet = true
                        } label: {
                            Image(systemName: "camera.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        }.sheet(isPresented: $shouldPresentImagePicker) {
                            SUImagePickerView(sourceType: shouldPresentCamera ? .camera : .photoLibrary, image: $image, isPresented: $shouldPresentImagePicker)
                        }.actionSheet(isPresented: $shouldPresentActionSheet) {
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
                
            }
            VStack (spacing: 20) {
                
                if !isEdited {
                    Text(itemDetail.nameItem ?? "")
                        .font(.title)
                        .foregroundColor(.black)
                    Text(itemDetail.descriptionItem ?? "")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                else {
                    Section {
                        HStack{
                            //  Text("Item")
                            TextField(itemDetail.nameItem ?? "", text: $newTitle)
                                .font(.title)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                    }.background(Color("gray1"))
                    Section {
                        // Text("Note")
                        TextField(itemDetail.descriptionItem ?? "", text: $newDescription)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }.background(Color("gray1"))
                    
                }
            }
            HStack {
                Spacer()
                if isEdited {
                    Button {
                        self.isEdited = !self.isEdited
                        image = nil
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                }
                
                Spacer()
                Button {
                    if isEdited {
                        
                        Task {
                            let size = CGSize(width: 300, height: 300)
                            let data : UIImage? = image?.getUIImage(newSize: size)
                            let imageBase64 = convertImageToBase64String(img: data)
                            await updateItem(imageBase64: imageBase64)
                        }
                    }
                    self.isEdited = !self.isEdited
                }label: {
                    if !isEdited {
                        Image(systemName: "pencil")
                    }else {
                        Image(systemName: "checkmark.circle")
                    }
                }
                Spacer()
            }
            // ส่วนที่แก้ไข
            HStack{
                Button(action: {
                    self.isPickerVisible.toggle()
                }) {
                    Text("Move")
                        .font(.headline)
                        .padding()
                    Image(systemName: "rectangle.portrait.and.arrow.forward.fill")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                                
                }
                
            }
                        .padding(.top, 20)
            if isPickerVisible {
                Picker("Select an Option", selection: $selectedOption) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }.labelsHidden()
            }

            Spacer()
            
        }
        
    }
    
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(itemDetail: Item(_id: "", imageitem: ""))
    }
}
