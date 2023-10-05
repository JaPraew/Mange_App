//
//  Place.swift
//  Manage_App
//
//  Created by Pare on 10/9/2566 BE.
//

import Foundation

struct Place: Codable, Identifiable, Hashable {
    
    var id: Int?
    var _id: String
    var imagelocation: String
    var namelocation: String
}
