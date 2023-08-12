//
//  ImageListCell.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 04.07.2023.
//

import UIKit

final class ImageListCell: UITableViewCell {
    static let identifier = "ImageListCell"
    
    @IBOutlet private var favorites: UIImageView!
    @IBOutlet private var contentImage: UIImageView!
    @IBOutlet private var dateLabel: UILabel!
    
    func configCell(image: UIImage?, date: Date, isFavorite: Bool) {
        contentImage.image = image
        favorites.image = isFavorite ? UIImage(named: "Favorites_Active") : UIImage(named: "Favorites_NoActive")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        dateLabel.text = dateFormatter.string(from: date)
    }
}
