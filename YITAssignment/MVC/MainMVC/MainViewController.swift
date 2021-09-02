//
//  ViewController.swift
//  YITAssignment
//
//  Created by Nikita Koniukh on 01/09/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let characterService = CharacterService()
    private var characters = [Character]()
    private var filteredCharacters = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        getCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        // navigation controller
        title = "Rick and Morty"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // search bar
        searchBar.placeholder = "Search"
        searchBar.delegate = self
    }
    
    private func initialization() {
        
        // tableview
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 60
        
        layout.itemSize = CGSize(width: (collectionView.frame.size.width - padding) / 1.5, height: (collectionView.frame.size.height - padding) / 2.1)
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        
        // cells
        collectionView.register(CharacterCollectionViewCell.nib(), forCellWithReuseIdentifier: CharacterCollectionViewCell.identifire)
    }
    
    private func getCharacters() {
        characterService.fetchCharacters { [weak self] charactersRes  in
            if let charactersArray = charactersRes {
                self?.characters = charactersArray
                self?.filteredCharacters = charactersArray
                self?.collectionView.reloadData()
            } else {
                let alert = UIAlertController(title: "oops...", message: "Something went wrong. We could not show you list of characters", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifire, for: indexPath) as! CharacterCollectionViewCell
        let character = filteredCharacters[indexPath.item]
        cell.configureCell(character: character)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = filteredCharacters[indexPath.item]
        performSegue(withIdentifier: "toDetails", sender: character)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetails") {
            guard let detailVC = segue.destination as? DetailsViewController else { return }
            let destination = sender as! Character
            detailVC.character = destination
        }
    }
    
    
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            filteredCharacters = characters.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        } else {
            filteredCharacters = characters
        }
        collectionView.reloadData()
    }
}

