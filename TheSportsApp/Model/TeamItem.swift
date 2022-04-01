//
//  TeamItem.swift
//  TheSportsApp
//
//  Created by Backup Admin on 3/30/22.
//

import Foundation

struct TeamItem: Codable {
    var id: String
    var loved: String?
    var name: String
    var stadium: String
    var formedYear: String
    var teamBadge: URL
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idTeam"
        case loved = "intLoved"
        case name = "strTeam"
        case stadium = "strStadium"
        case formedYear = "intFormedYear"
        case teamBadge = "strTeamBadge"
        case description = "strDescriptionEN"
    }
}
