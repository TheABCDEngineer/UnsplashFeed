//
//  ImageListCell.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 04.07.2023.
//

import UIKit
import Kingfisher

final class ImageListCell: UITableViewCell {
    static let identifier = "ImageListCell"
    
    @IBOutlet private weak var favoritesButton: UIButton!
    @IBOutlet private weak var contentImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentImage.kf.cancelDownloadTask()
    }
    
    func configCell(imageStringUrl: String, date: Date, isFavorite: Bool) {
        let url = URL(string: imageStringUrl)
        contentImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Placeholder")
        )
        
        let image = isFavorite ? UIImage(named: "Favorites_Active") : UIImage(named: "Favorites_NoActive")
        favoritesButton.setImage(image, for: .normal)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    @IBAction private func onFavoritesButtonClick() {
        let buttonImage = favoritesButton.currentImage
        var newImageState = UIImage(named: "Favorites_Active")
        if buttonImage == UIImage(named: "Favorites_Active") {
            newImageState = UIImage(named: "Favorites_NoActive")
        }
        favoritesButton.setImage(newImageState, for: .normal)
    }
}
