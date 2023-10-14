//
//  AsyncImageHack.swift
//  HomeManagement
//
//  Created by Pare on 15/10/2566 BE.
//

import SwiftUI
struct AsyncImageHack<Content> : View where Content : View {
    let url: URL?
    @ViewBuilder let content: (AsyncImagePhase) -> Content
    @State private var currentUrl: URL?
    var body: some View {
        AsyncImage(url: currentUrl, content: content)
            .onAppear
        {
            if currentUrl == nil {
                DispatchQueue.main.async {
                    currentUrl = url
                    
                }
                
            }
            
        }
        
    }
    
}
