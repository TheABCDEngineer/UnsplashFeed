//
//  ViewController.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 30.06.2023.
//

import UIKit

class ImageListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        cell.contentImage.image = UIImage(named: String(indexPath.row))
        cell.favorites.image = Bool.random() ? UIImage(named: "Favorites_Active") : UIImage(named: "Favorites_NoActive")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        cell.dateLabel.text = dateFormatter.string(from: Date())
    }

}

extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.identifier, for: indexPath)
                
        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: String(indexPath.row)) else {
            return 0
        }
        let imageViewWidth = tableView.bounds.width
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale
        return cellHeight
    }
}
