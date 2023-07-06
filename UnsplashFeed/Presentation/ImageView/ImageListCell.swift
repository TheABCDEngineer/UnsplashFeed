//
//  ImageListCell.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 04.07.2023.
//

import UIKit

final class ImageListCell: UITableViewCell {
    static let identifier = "ImagesListCell"
    
    @IBOutlet var favorites: UIImageView!
    @IBOutlet var contentImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
}
