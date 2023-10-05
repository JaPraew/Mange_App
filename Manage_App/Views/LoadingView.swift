//
//  LoadingView.swift
//  Manage_App
//
//  Created by Pare on 16/9/2566 BE.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView() {
                Text("Loading...")
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
