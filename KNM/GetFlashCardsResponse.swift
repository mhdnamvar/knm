//
//  GetFlashCardsResponse.swift
//  KNM
//
//  Created by Mohammad Namvar on 27/03/2019.
//  Copyright © 2019 Mohammad Namvar. All rights reserved.
//

import Foundation

class GetFlashCardResponse: Codable {
    
    var id: Int
    var name: String
    var description: String
    var category: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case category = "category"
    }
    
}
