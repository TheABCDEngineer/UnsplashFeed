//
//  ViewController.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 30.06.2023.
//

import UIKit

final class ImageListViewController: UIViewController {
    private let singleImageViewIdentifier = "toSingleImageView"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBOutlet private var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: ImageListCell.identifier, bundle: nil),
            forCellReuseIdentifier: ImageListCell.identifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case singleImageViewIdentifier:
            let viewController = segue.destination as! SingleImageViewController
            viewController.image = sender as? UIImage
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.identifier, for: indexPath) as? ImageListCell else {
            return UITableViewCell()
        }
        cell.configCell(
            image: UIImage(named: String(indexPath.row)),
            date: Date(),
            isFavorite: Bool.random()
        )
        return cell
    }
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(
            withIdentifier: singleImageViewIdentifier,
            sender: UIImage(named: String(indexPath.row))
        )
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