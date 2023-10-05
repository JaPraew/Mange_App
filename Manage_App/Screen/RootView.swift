//
//  RootView.swift
//  Manage_App
//
//  Created by Pare on 1/3/2566 BE.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack{
            if !showSignInView{
                NavigationStack{
                    AppTabBarView()
                  
                }
            } else {
                AuthenticationView(showSignInViwe: $showSignInView) {
                    
                }
            }
        }
        .onAppear {
            let authUser = try? AuthenticationMamager.shared.getAuthenticationMamager()
            self.showSignInView = authUser == nil
        }
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
