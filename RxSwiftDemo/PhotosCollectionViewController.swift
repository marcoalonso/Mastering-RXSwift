//
//  PhotosCollectionViewController.swift
//  RxSwiftDemo
//
//  Created by marco rodriguez on 18/07/22.
//

import Foundation
import UIKit
import Photos
import RxSwift

class PhotosCollectionViewController: UICollectionViewController {
    
    //creamos un SUBJECT al que puedo omitir el valor y al que se pueden suscribir
    private let selectedPhotosSubject = PublishSubject<UIImage>()
    
    //Crearemos un observable
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotosSubject.asObservable()
    }
    
    //Aqui vamos a guardar las imagenes
    private var images = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pupulatePhotos()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = self.images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 400, height: 300), contentMode: .aspectFit, options: nil) { [weak self] image, info in
            guard let info = info else { return }
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            
            //SI aun no se ah degradado?
            if !isDegradedImage {
                if let image = image {
                    //Se le agrega la imagen al sujeto
                    self?.selectedPhotosSubject.onNext(image)
                    self?.dismiss(animated: true)
                }
            }
            
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else { fatalError("Error no se encontro PhotoCollectionViewCell")}
        
        let asset = self.images[indexPath.row]
        
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: nil) { image, _ in
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
        }
        return cell
    }
    
    
    func pupulatePhotos() {
        //request permision of user
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            
            switch status {
            case .notDetermined:
                print("notDetermined")
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
            case .authorized:
                print("authorized")
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                
                //Queremos enumerar todas las fotos que recibamos
                assets.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }
                //Mostrar la mas reciente primero
                self?.images.reverse()
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                
                
            case .limited:
                print("limited")
            @unknown default:
                print("Error")
            }
            
            
        }
    }
}
