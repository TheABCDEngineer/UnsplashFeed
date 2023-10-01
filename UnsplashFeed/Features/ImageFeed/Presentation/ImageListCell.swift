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
    
    private var delegate: ImageListCellDelegate?
    private var imageListRow: Int = 0
    
    @IBOutlet private weak var favoritesButton: UIButton!
    @IBOutlet private weak var contentImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentImage.kf.cancelDownloadTask()
    }
    
    func configCell(imageStringUrl: String, date: Date, isFavorite: Bool?) {
        let url = URL(string: imageStringUrl)
        contentImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Placeholder")
        )
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        dateLabel.text = dateFormatter.string(from: date)
        
        guard let isFavorite else {
            favoritesStateLoading(true)
            return
        }
        
        let image = isFavorite ? UIImage(named: "Favorites_Active") : UIImage(named: "Favorites_NoActive")
        favoritesButton.setImage(image, for: .normal)
    }
    
    func setDelegate(_ delegate: ImageListCellDelegate) {
        self.delegate = delegate
    }
    
    func setRow(_ value: Int) {
        imageListRow = value
    }
    
    private func favoritesStateLoading(_ isLoading: Bool) {
        favoritesButton.isHidden = isLoading
        activityIndicator.isHidden = !isLoading
    }
    
    @IBAction private func onFavoritesButtonClick() {
        favoritesStateLoading(true)
        delegate?.changeLike(for: imageListRow) { [weak self] isLiked in
            guard let self else { return }
            let image = isLiked ? UIImage(named: "Favorites_Active") : UIImage(named: "Favorites_NoActive")
            self.favoritesButton.setImage(image, for: .normal)
            self.favoritesStateLoading(false)
        }
    }
}
