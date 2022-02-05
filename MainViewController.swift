//
//  ViewController.swift
//  Summer
//
//  Created by 전윤현 on 2022/02/03.
//

import UIKit

extension UIImage {
    func resize(to targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

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
    
    lazy var thumbnails: [UIImage] = {
        self.list.map{$0.convert(UIImage(named: "thumbnail")!)}
    }()
}

class FilterCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
}

class MainViewController: UIViewController {
    private var manager = FilterManager()
    private var selectedIndex: Int?
    private var selectedImage: UIImage = UIImage(named: "photo")!
    
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
        if let image = info[.originalImage] as? UIImage {
            let resizedImage = image.resize(to: CGSize(width: 800, height: 800))!
            
            self.selectedImage = resizedImage
            self.imageView.image = resizedImage
        }
        
        self.dismiss(animated: true, completion: nil)
        print("did finish")
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        manager.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        
        cell.imageView.image = manager.thumbnails[indexPath.item]
        cell.nameLabel.text = manager.list[indexPath.item].name
        cell.nameLabel.textColor = (selectedIndex == indexPath.item) ? .black : .lightGray
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        let filter = manager.list[index]
        
        self.selectedIndex = index
        self.imageView.image = filter.convert(selectedImage)
        
        self.collectionView.reloadData()
    }
}

