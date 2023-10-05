//
//  AuthenticationViw.swift
//  Manage_App
//
//  Created by Pare on 1/4/2566 BE.
//

import SwiftUI
import Firebase
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import FirebaseCore


@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    var email:String? = nil
    
    func signInGoogle() async throws{
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        self.email = tokens.email
        try await AuthenticationMamager.shared.signInWithGoogle(tokens: tokens)
       
    }
    
    
    
}

struct AuthenticationView: View {
    
    let defaults = UserDefaults.standard
    @EnvironmentObject private var model: PlaceModel
    
    private func fetchUser(email: String) async {
        do {
            try await model.login(login: Login(_id: "",email: email))
            
            defaults.set(model.login._id, forKey: "Owner")
        } catch {
            print(error)
        }
        
    }
//    func  fetchUser(email: String?) async {
//        // prepare json data
//        let json: [String: Any] = ["email": email]
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])
//      //  let jsonData = try? JSONSerialization.data(withJSONObject: json)
//
//        // create post request
//        let url = URL(string: "http://172.20.10.3:3001/api/user/create")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        // insert json data to the request
//        request.httpBody = jsonData
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//
//            guard data != nil else {
//                print("No data received")
//                return
//            }
//            if let data = data {
//                do {
//                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                        // Process the JSON response
//                        print("Response JSON: \(jsonResponse)")
//
//                        // Access specific values in the JSON response
//                        if let email = jsonResponse["email"] as? String {
//                            print("Title: \(email)")
//                        }
//
//                    }
//                } catch {
//                    print("Title: error")
//                }
//            }
//           // let email = "example@example.com"
//           // UserDefaults.standard.set(email, forKey: "userEmail")
//        }
//        .resume()
//    }
    
  //  @Binding var showSignInView: Bool
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInViwe: Bool
    var onLogin: () -> Void
    var body: some View {
        
        ZStack{
            Image("login")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            
                
                VStack{
                    
                    Spacer().frame(height: 200)
                    
                    GoogleSignInButton(viewModel: GoogleSignInButtonViewModel( scheme: .light, style: .wide , state: .normal)){
                        Task{
                            do{
                                try await viewModel.signInGoogle()
                                await fetchUser(email:viewModel.email ?? "")
                                defaults.set(viewModel.email, forKey: "userEmail")
                                showSignInViwe = false
                                onLogin()
                            }catch{
                                print(error)
                            }
                        }
                    
                }
                .cornerRadius(20)
                .frame(width: 350, height: 70 )
                
               
            }
            
        }
       
      
      //  .navigationTitle("Sign in")
    }
}

struct AuthenticationViw_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            
            AuthenticationView(showSignInViwe: .constant(false)) {
                
            }
        }
       
    }
}
