//
//  League.swift
//  TheSportsApp
//
//  Created by Backup Admin on 3/31/22.
//

import Foundation

struct League: Codable {
    var id: String
    var name: String
    var sport: String
    var nameAlternate: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idLeague"
        case name = "strLeague"
        case sport = "strSport"
        case nameAlternate = "strLeagueAlternate"
    }
}
