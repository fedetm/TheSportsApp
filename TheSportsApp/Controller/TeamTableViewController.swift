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
    var imageLoadTask: [IndexPath: Task<Void, Never>] = [:]
    
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        Task.init {
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
        }
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        imageLoadTask[indexPath]?.cancel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Cancel image fetching tasks that are no longer needed
        imageLoadTask.forEach { key, value in value.cancel() }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
