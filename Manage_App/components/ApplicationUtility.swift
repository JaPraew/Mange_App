//
//  Application.swift
//  Manage_App
//
//  Created by Pare on 28/3/2566 BE.
//
import SwiftUI
import UIKit

final class ApplicationUtility{
    static var getRootViweController: UIViewController {
        guard
            let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else{
            return .init()
        }
        
        guard
            let root = screen.windows.first?.rootViewController
        else{
            return .init()
        }
        return root
    }
}
