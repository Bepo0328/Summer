//
//  ViewController.swift
//  Summer
//
//  Created by 전윤현 on 2022/02/03.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = nil
    }
    
    @IBAction func presentAlbum() {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func presentCamera() {
        print("camera")
    }
    
    @IBAction func saveImage() {
        print("save")
    }
}

extension MainViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        print("did cancel")
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("did finish")
    }
}
