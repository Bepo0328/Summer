//
//  ViewController.swift
//  Summer
//
//  Created by 전윤현 on 2022/02/03.
//

import UIKit

protocol Filter {
    var name: String { get }
    func convert(_ image: UIImage) -> UIImage
}

struct SummerFilter: Filter {
    let name: String
    let identifier: String
    
    func convert(_ image: UIImage) -> UIImage {
        let context = CIContext(options: nil)
        let source = CIImage(image: image)
        
        let filter = CIFilter(name: identifier)
        
        filter?.setDefaults()
        filter?.setValue(source, forKey: kCIInputImageKey)
        
        let outputCGImage = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)
        let filteredImage = UIImage(cgImage: outputCGImage!)
        
        return filteredImage
    }
}

struct FilterManager {
    let list: [Filter] = [
        SummerFilter(name: "Vivid", identifier: "CIPhotoEffectChrome"),
        SummerFilter(name: "Fade", identifier: "CIPhotoEffectFade"),
        SummerFilter(name: "Instant", identifier: "CIPhotoEffectInstant"),
        SummerFilter(name: "Mono", identifier: "CIPhotoEffectMono"),
        SummerFilter(name: "Noir", identifier: "CIPhotoEffectNoir"),
        SummerFilter(name: "Process", identifier: "CIPhotoEffectProcess"),
        SummerFilter(name: "Tonal", identifier: "CIPhotoEffectTonal"),
        SummerFilter(name: "Transfer", identifier: "CIPhotoEffectTransfer"),
        SummerFilter(name: "Curve", identifier: "CILinearToSRGBToneCurve"),
        SummerFilter(name: "Linear", identifier: "CISRGBToneCurveToLinear")
    ]
}

class FilterCell: UICollectionViewCell {
    var filter: Filter! {
        didSet {
            nameLabel.text = filter.name
            imageView.image = filter.convert(UIImage(named: "photo")!)
        }
    }
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
}

class MainViewController: UIViewController {
    private let manager = FilterManager()
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var toolbar: UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toolbar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        
        self.toolbar.layer.shadowColor = UIColor.black.cgColor
        self.toolbar.layer.shadowRadius = 5
        self.toolbar.layer.shadowOpacity = 0.05
        self.toolbar.layer.shadowOffset = CGSize(width: 0, height: -10)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
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
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("did finish")
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        manager.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        let filter = manager.list[indexPath.item]
        
        cell.filter = filter
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    
}

