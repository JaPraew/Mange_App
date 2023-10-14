//
//  ItemView.swift
//  Manage_App
//
//  Created by Pare on 1/3/2566 BE.
//

import SwiftUI

struct ItemView: View {
    let idLocation: String
    
    let userDefaults = UserDefaults.standard
    
    @EnvironmentObject private var model: PlaceModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var image: Image? = Image("roomempty")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State private var nameItem: String = ""
    @State private var category: String = ""
    @State private var note: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        // WARNING: Force wrapped image for demo purpose
        NavigationView{
            VStack{
                
                image!
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                
                    .foregroundColor(.blue)
                    .shadow(radius: 10)
                
                Button("Add Image +"){
                    self.shouldPresentActionScheet = true
                    
                }
                .sheet(isPresented: $shouldPresentImagePicker) {
                    SUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
                }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                    ActionSheet(title: Text("Take Image"), message: Text("Choose image source"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                        self.shouldPresentImagePicker = true
                        self.shouldPresentCamera = true
                    }), ActionSheet.Button.default(Text("Photo Library"), action: {
                        self.shouldPresentImagePicker = true
                        self.shouldPresentCamera = false
                    }), ActionSheet.Button.cancel()])
                }
                
                
                Section{
                    
                    TextField("Name", text: $nameItem)
                    // TextField("Category", text: $category)
                    
                    
                    TextField("Note", text: $note)
                    
                    
                }
                .padding()
                
                Button("Save") {
                    Task {
                        let size = CGSize(width: 300, height: 300)
                        let data : UIImage? = image?.getUIImage(newSize: size)
                        let imageBase64 = convertImageToBase64String(img: data)
                        await saveItem(base64: imageBase64)
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                
            }
            //VStack
            //.navigationBarTitle(Text("Add Item"))
        }
    }
    
    private func saveItem(base64: String) async {
        do {
            let ownerId = userDefaults.string(forKey: "Owner") ?? ""
            let itemRequest = ItemRequest(nameItem: nameItem, imagebase64: base64, imagename: "\(nameItem).jpg", descriptionItem: note, idlocation: idLocation, owner: ownerId)
            try await model.addItem(itemRequest: itemRequest)
            
            presentationMode.wrappedValue.dismiss()
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
}
struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(idLocation: "")
    }
}
