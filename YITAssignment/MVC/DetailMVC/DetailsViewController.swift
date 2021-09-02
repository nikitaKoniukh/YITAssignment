//
//  DetailsViewController.swift
//  YITAssignment
//
//  Created by Nikita Koniukh on 01/09/2021.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - outlets
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var character: Character?
    var image: UIImage?
    private let episodeService = EpisodeService()
    private let characterService = CharacterService()
    private var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
    
    private func initialization() {
        // navigation controller
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(share(sender:)))
        
        if let character = character{
            title = character.name
            characterService.downloadImage(from:URL(string: character.image)!) { image in
                self.image = image
                self.characterImageView.image = image
            }
            statusLabel.text = "Status: \(character.status)"
            speciesLabel.text =  "Spesies: \(character.species)"
            genderLabel.text =  "Gender: \(character.gender)"
            locationLabel.text = "Location: \(character.location.name)"
            
            episodeService.fetchEpisodes(urlArray: character.episode) { episodesResult in
                if let episodes = episodesResult {
                    self.episodes = episodes
                    self.tableView.reloadData()
                }
            }
        }
        
        // table view
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func share(sender:UIView){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsEndImageContext()
        
        if let status = character?.status,
           let name = character?.name,
           let species = character?.species,
           let gender = character?.gender,
           let location = character?.location.name {
            
            let description = "\(status) \(species) \(gender) \(location)"
            
            let objectsToShare = [name, description, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [.airDrop, .addToReadingList, .mail, .message]
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    deinit {
        print("De init")
    }
    
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
        let episode = episodes[indexPath.row]
        cell.textLabel?.text = episode.name
        cell.detailTextLabel?.text = episode.episode
        return cell
    }
    
    
}
