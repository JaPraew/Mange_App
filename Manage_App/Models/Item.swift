//
//  Item.swift
//  Manage_App
//
//  Created by Pare on 16/9/2566 BE.
//

import Foundation

struct Item: Codable, Identifiable, Hashable {
    
    var id: Int?
    var _id: String
    var nameItem: String?
    var imageitem: String?
    var descriptionItem: String?
    var idlocation: String?
    var owner: String?
    var shared_with_id: String?
}
