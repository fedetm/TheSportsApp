//
//  TeamController.swift
//  TheSportsApp
//
//  Created by Backup Admin on 3/30/22.
//

import Foundation
import UIKit

class TeamController {
    
    static let shared = TeamController()
    let baseURL = URL(string: "https://www.thesportsdb.com/api/")
    
    enum TeamControllerError: Error, LocalizedError {
        case leaguesNotFound
        case teamItemsNotFound
        case imageDataMissing
    }
    
    func fetchLeagues() async throws -> [League] {
        let leaguesURL = (baseURL?.appendingPathComponent("v1/json/3/all_leagues.php"))!
        let (data, response) = try await URLSession.shared.data(from: leaguesURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw TeamControllerError.leaguesNotFound
        }
        
        let decoder = JSONDecoder()
        let leaguesResponse = try decoder.decode(LeagueResponse.self, from: data)
        
        return leaguesResponse.leagues
    }
    
    func fetchTeamItems(forLeague leagueName: String) async throws -> [TeamItem] {
        let baseTeamURL = (baseURL?.appendingPathComponent("v1/json/3/search_all_teams.php"))!
        var components = URLComponents(url: baseTeamURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "l", value: leagueName)]
        let teamURL = components.url!
        
        let (data, response) = try await URLSession.shared.data(from: teamURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw TeamControllerError.teamItemsNotFound
        }
        
        let decoder = JSONDecoder()
        let teamResponse = try decoder.decode(TeamResponse.self, from: data)
        
        return teamResponse.teams
    }
    
    func fetchImage(from url: URL) async throws -> UIImage {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
                  throw TeamControllerError.imageDataMissing
              }
        
        guard let image = UIImage(data: data) else {
            throw TeamControllerError.imageDataMissing
        }
        
        return image
    }
}
