//
//  ViewController.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 30.06.2023.
//

import UIKit

final class ImageListViewController: UIViewController {
    var presenter = Creator.createImageListPresenter()
    private let singleImageViewIdentifier = "toSingleImageView"
    private var photos = [PhotoModel]()
    
    @IBOutlet private var tableView: UITableView!

//MARK: - Lifecycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: ImageListCell.identifier, bundle: nil),
            forCellReuseIdentifier: ImageListCell.identifier)
        
        presenter.setPhotosObserver{ [weak self] photos in
            guard let self else { return }
            if photos == nil { return }
            self.updateTableViewAnimated(photos!)
        }
        
        presenter.setErrorStateObserver{ [weak self] errorAlertModel in
            guard let self else { return }
            if errorAlertModel == nil { return }
            AlertDialog.showAlert(self, model: errorAlertModel!)
        }
        
        presenter.getPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case singleImageViewIdentifier:
            guard let viewController = segue.destination as? SingleImageViewController else {
                assertionFailure("Can't find SingleImageViewController")
                return
            }
            viewController.imageStringUrl = sender as? String
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
}
//MARK: - Private methods
private extension ImageListViewController {
    func updateTableViewAnimated(_ photos: [PhotoModel]) {
        let from = self.photos.count
        let to = from + photos.count
        self.photos.append(contentsOf: photos)
        
        tableView.performBatchUpdates {
            let indexPaths = (from..<to).map { i in
                    IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}

//MARK: - UITableViewDataSource
extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImageListCell.identifier, for: indexPath
        ) as? ImageListCell else {
            return UITableViewCell()
        }
        cell.setDelegate(self)
        cell.setRow(indexPath.row)
        
        if photos.count - indexPath.row == 3 { presenter.getPhotosNextPage() }
        
        let photo = photos[indexPath.row]
        cell.configCell(
            imageStringUrl: photo.thumbImageURL ?? "",
            date: photo.createdAt,
            isFavorite: photo.isLiked
        )
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(
            withIdentifier: singleImageViewIdentifier,
            sender: photos[indexPath.row].largeImageURL
        )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        
        let imageViewWidth = tableView.bounds.width
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale
        return cellHeight
    }
}

//MARK: - AlertPresenterProtocol
extension ImageListViewController: AlertPresenterProtocol {
    func present(_ alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}

//MARK: - ImageListCellDelegate
extension ImageListViewController: ImageListCellDelegate {
    func changeLike(for photoModelNumber: Int, _ completion: @escaping (Bool) -> Void) {
        let photoModelUnknownFavoritesState = presenter.rebuildPhotoModel(
            model: photos[photoModelNumber],
            isLiked: nil
        )
        
        presenter.changeLike(for: photos[photoModelNumber]) { [weak self] photoModel in
            guard let self else { return }
            self.photos[photoModelNumber] = photoModel
            completion(photoModel.isLiked ?? false)
        }
        
        photos[photoModelNumber] = photoModelUnknownFavoritesState
    }
}
