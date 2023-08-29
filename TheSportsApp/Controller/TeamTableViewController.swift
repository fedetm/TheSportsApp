//
//  TeamTableViewController.swift
//  TheSportsApp
//
//  Created by Backup Admin on 3/30/22.
//

import UIKit

class TeamTableViewController: UITableViewController {
    
    let league: League
    var teamItems = [TeamItem]()
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    init?(coder: NSCoder, league: League) {
        self.league = league
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = league.name.capitalized
        
        Task.init {
            do {
                let teamItems = try await TeamController.shared.fetchTeamItems(forLeague: league.name)
                updateUI(with: teamItems)
            } catch {
                displayError(error, title: "Failed to Fetch League Teams for \(self.league.name)")
            }
        }
    }
    
    func updateUI(with teamItems: [TeamItem]) {
        self.teamItems = teamItems
        self.tableView.reloadData()
    }
    
    func displayError(_ error: Error, title: String) {
        guard let _ = viewIfLoaded?.window else { return }
        
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBSegueAction func showTeamItem(_ coder: NSCoder, sender: Any?) -> TeamItemDetailViewController? {
        
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        let teamItem = teamItems[indexPath.row]
        return TeamItemDetailViewController(coder: coder, teamItem: teamItem)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamItem", for: indexPath)

        configure(cell, forItemAt: indexPath)
        
        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        let teamItem = teamItems[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = teamItem.name
        content.secondaryText = "Stadium: \(teamItem.stadium)\nFormer Year: \(teamItem.formedYear)"
        content.image = UIImage(systemName: "photo.on.rectangle")
        cell.contentConfiguration = content
        
        imageLoadTasks[indexPath] = Task.init {
            if let image = try? await
                TeamController.shared.fetchImage(from: teamItem.teamBadge) {
                
                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath == indexPath {
                    
                    var content = cell.defaultContentConfiguration()
                    content.text = teamItem.name
                    content.secondaryText = "Stadium: \(teamItem.stadium)\nFormer Year: \(teamItem.formedYear)"
                    content.image = image
                    cell.contentConfiguration = content
                }
            }
            imageLoadTasks[indexPath] = nil
        }
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        imageLoadTasks[indexPath]?.cancel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        imageLoadTasks.forEach { key, value in value.cancel() }
    }

}
