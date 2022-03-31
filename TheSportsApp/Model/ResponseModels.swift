//
//  ResponseModels.swift
//  TheSportsApp
//
//  Created by Backup Admin on 3/30/22.
//

import Foundation

struct TeamResponse {
    let items: [TeamItem]
}

struct LeagueResponse: Codable {
    let leagues: [String]
}
