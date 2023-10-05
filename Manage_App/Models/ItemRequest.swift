//
//  ItemRequest.swift
//  Manage_App
//
//  Created by Pare on 17/9/2566 BE.
//

import Foundation

struct ItemRequest : Codable {

    var nameItem: String = ""
    var imagebase64: String = ""
    var imagename: String = ""
    var descriptionItem: String = ""
    var idlocation: String = ""
    var owner: String = ""
}
