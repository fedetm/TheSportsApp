//
//  TeamItemDetailViewController.swift
//  TheSportsApp
//
//  Created by Backup Admin on 3/30/22.
//

import UIKit

class TeamItemDetailViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageVIew: UIImageView!
    @IBOutlet var lovedLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    let teamItem: TeamItem
    
    init?(coder: NSCoder, teamItem: TeamItem) {
        self.teamItem = teamItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    func updateUI() {
        nameLabel.text = teamItem.name
        lovedLabel.text = "Loved: \(teamItem.loved ?? "Unknown")"
        descriptionLabel.text = teamItem.description
        
        Task.init {
            if let image = try? await TeamController.shared.fetchImage(from: teamItem.teamBadge) {
                imageVIew.image = image
            }
        }
    }

}
