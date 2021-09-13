//
//  ViewController.swift
//  YITAssignment
//
//  Created by Nikita Koniukh on 01/09/2021.
//

import UIKit

class CharactersViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Properties
    private var characters = [Character]()
    private var filteredCharacters = [Character]()
    
    // MARK: - View model
    let viewModel = CharactersViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        addViews()
        bindViewModel()
        loadCharacters(showLoading: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configNavigationController()
    }
    
    // MARK: - Private
    private func configCollectionView() {
        // tableview
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 60
        
        layout.itemSize = CGSize(width: (collectionView.frame.size.width - padding) / 1.5, height: (collectionView.frame.size.height - padding) / 2.3)
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        
        // cells
        collectionView.register(CharacterCollectionViewCell.nib(), forCellWithReuseIdentifier: CharacterCollectionViewCell.identifire)
    }
    
    private func configNavigationController() {
        // navigation controller
        title = "Rick and Morty"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // search bar
        searchBar.placeholder = "Search"
        searchBar.delegate = self
    }
    
    private func addViews() {
        collectionView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private var isLoading: Bool = false {
        didSet {
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
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
    
    private func loadCharacters(showLoading: Bool) {
        if showLoading {
            isLoading = true
        }
        viewModel.loadCharacters()
    }
    
    // MARK: - Actions
    @objc func refresh(_ sender: UIRefreshControl) {
        loadCharacters(showLoading: false)
    }
    
    private func bindViewModel() {
        viewModel.update = { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            self.collectionView.reloadData()
        }

        viewModel.error = { [weak self] error in
            guard let self = self else { return }
            self.isLoading = false
            self.showError(error)
        }
    }
}

extension CharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifire, for: indexPath) as! CharacterCollectionViewCell
        let character = viewModel.characters[indexPath.item]
        cell.configureCell(character: character)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.item]
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

extension CharactersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCharacters(with: searchText)
    }
}

