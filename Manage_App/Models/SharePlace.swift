//
//  SharePlace.swift
//  Manage_App
//
//  Created by Pare on 30/9/2566 BE.
//

import Foundation

struct SharePlace : Codable {
    
    var _id: String? = ""
    var imagelocation: String? = ""
    var namelocation: String? = ""
    var owner: String? = ""
    var sharedWithId: String? = ""
    var checkemailerror: [String]? = []
}
