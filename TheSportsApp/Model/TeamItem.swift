//
//  TeamItem.swift
//  TheSportsApp
//
//  Created by Backup Admin on 3/30/22.
//

import Foundation

struct TeamItem: Codable {
    var id: Int
    var name: String
    var stadium: String
    var formedYear: Int
    var teamBadge: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idTeam"
        case name = "strTeam"
        case stadium = "strStadium"
        case formedYear = "intFormedYear"
        case teamBadge = "strTeamBadge"
    }
}