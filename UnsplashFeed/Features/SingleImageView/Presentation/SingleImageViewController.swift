//
//  SingleImageViewController.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 06.08.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            if isViewLoaded {
                initImage(self.image)
            }
        }
    }
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        initImage(self.image)
    }
    
    private func initImage(_ image: UIImage?) {
        imageView.image = image
        if image == nil { return }
        configureScrollView(imageSize: image!.size)
    }
    
    private func configureScrollView(imageSize: CGSize) {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        let visibleRectSize = scrollView.bounds.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    @IBAction private func onBackButtonClick() {
        dismiss(animated: true)
    }
    
    @IBAction private func onShareButtonClick() {
        guard let image = self.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
