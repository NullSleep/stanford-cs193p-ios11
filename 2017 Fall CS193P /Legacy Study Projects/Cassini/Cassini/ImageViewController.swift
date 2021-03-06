//
//  ImageViewController.swift
//  Cassini
//
//  Created by Carlos Arenas on 1/16/19.
//  Copyright © 2019 Polygon. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    // MARK: - IBOutlets and class vars
//    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // As soon as scrollView gets hooked up by interface builder I'm going to ask scrollView to add a subView my ImageView
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0 // Less that 1.0 means that your below the image natural resolution
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    var imageView = UIImageView()
    
    // Model of tre MVC.
    // If someone set's my model I'm going to set my imageView.image = nil
    var imageURL: URL? {
        didSet {
            //scrollView.contentSize = imageView.frame.size
            imageView.image = nil
            
            // I'm only going to fetch this image is somone sets my model and I'm on screen
            // If the view has a window it means it's on screen
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            // Everytime I set my image I resize the imageView and the scrollView
            imageView.sizeToFit() // SizeToFit = Make yourself your intrinsic size
            scrollView?.contentSize = imageView.frame.size // The scrollView contentSize needs to updated for it to scroll
            spinner?.stopAnimating()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if imageURL == nil {
//            imageURL = DemoURLs.stanford
//        }
    }

}

extension ImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension ImageViewController {
    
    private func fetchImage() {
        if let url = imageURL {
//            do {
//                let urlContents = try Data(contentsOf: url)
//            } catch let error {
//            }
            
            spinner.startAnimating()
            // self = the ImageViewController instance may not exist any more, if loading the image takes too long the user might have left
            // so in this intance it's important to have weak self
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                // Setting the image variable triggers it's computed property UI code for modifying the imageView and the scroll view which
                // are UI elements and UI elements must only be updated in the Main Queue (thread)
                DispatchQueue.main.async {
                    // If too much time happened and we went back and then loaded a new image, we need to make sure they match
                    if let imageData = urlContents, url == self?.imageURL {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
