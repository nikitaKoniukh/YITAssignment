//
//  DetailsViewController.swift
//  YITAssignment
//
//  Created by Nikita Koniukh on 01/09/2021.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View model
    let viewModel = DetailsViewModel()
    
    var character: Character?
    var image: UIImage?
    private var episodes = [Episode]()
    
    // MARK: - Lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        configNavigationController()
        configTableView()
        loadEpisodes(showLoading: true)
        bindViewModel()
    }
    
    
    // MARK: - Private
    private func bindViewModel() {
        viewModel.update = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        viewModel.error = { [weak self] error in
            guard let self = self else { return }
            self.showError(error)
        }
    }
    
    private func loadEpisodes(showLoading: Bool) {
        if let episode = character?.episode {
            viewModel.loadEpisodes(with: episode)
        }
        
    }
    
    private func configNavigationController() {
        // navigation controller
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(share(sender:)))
    }
    
    private func configTableView() {
        // table view
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func initialization() {
        if let character = character{
            title = character.name
            guard let imageUrl = URL(string: character.image)  else {
                return
            }
            
            viewModel.downloadImage(from: imageUrl) { image in
                self.image = image
                self.characterImageView.image = image
            }
            
            statusLabel.text = "Status: \(character.status)"
            speciesLabel.text =  "Spesies: \(character.species)"
            genderLabel.text =  "Gender: \(character.gender)"
            locationLabel.text = "Location: \(character.location.name)"
        }
    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(
            title: NSLocalizedString("oops...", comment: ""),
            message: error.localizedDescription,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            alertController.dismiss(animated: true)
        }
    }
    
    // MARK: - Actions
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
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
        let episode = viewModel.episodes[indexPath.row]
        cell.textLabel?.text = episode.name
        cell.detailTextLabel?.text = episode.episode
        return cell
    }
}
