//
//  CharacterCollectionViewCell.swift
//  YITAssignment
//
//  Created by Nikita Koniukh on 01/09/2021.
//

import UIKit
import SDWebImage

class CharacterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    static let identifire = "CharacterCollectionViewCell"
    
    override func layoutSubviews() {
        containerView.setupCardView(cRadius: 8.0, sColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: Float(1)), sOffset: CGSize(width: 4, height: 4), sRadius: 4.0, sOpacity: 0.5)
    }
    
    func configureCell(character: Character) {
        guard let url = URL(string: character.image) else {
            return
        }
        
        characterImageView.sd_setImage(with: url, placeholderImage: nil)
        nameLabel.text = character.name
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CharacterCollectionViewCell", bundle: nil)
    }

}
