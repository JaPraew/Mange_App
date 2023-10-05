//
//  SearchRequest.swift
//  Manage_App
//
//  Created by Pare on 30/9/2566 BE.
//

import Foundation

struct SearchRequest : Codable {
    var word: String = ""
    var ownerid: String
}
