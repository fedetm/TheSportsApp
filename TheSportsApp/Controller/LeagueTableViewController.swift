//
//  LeagueTableViewController.swift
//  TheSportsApp
//
//  Created by Backup Admin on 3/30/22.
//

import UIKit

class LeagueTableViewController: UITableViewController {
    let teamController = TeamController()
    var leagues = [League]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Task.init {
            do {
                let leagues = try await teamController.fetchLeagues()
                updateUI(with: leagues)
            } catch {
                displayError(error, title: "Failed to Fetch Leagues")
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updateUI(with leagues: [League]) {
        self.leagues = leagues
        self.tableView.reloadData()
    }
    
    func displayError(_ error: Error, title: String) {
        guard let _ = viewIfLoaded?.window else {return}
        
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBSegueAction func showTeams(_ coder: NSCoder, sender: Any?) -> TeamTableViewController? {
        
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        let league = leagues[indexPath.row]
        return TeamTableViewController(coder: coder, league: league)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "League", for: indexPath)
        configureCell(cell, forLeagueAt: indexPath)

        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, forLeagueAt indexPath: IndexPath) {
        
        let league = leagues[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = league.name.capitalized
        cell.contentConfiguration = content
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
