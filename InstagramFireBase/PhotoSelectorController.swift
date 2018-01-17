//
//  PhotoSelectorController.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/12/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController ,UICollectionViewDelegateFlowLayout {
    
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        setupNavigationButtons()
        
        
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: headerId)
        
        fetchPhotos()
        
    }
    
    var images = [UIImage]()
    var assets = [PHAsset]()
    
    fileprivate func fetchPhotos() {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 100
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        fetchOptions.sortDescriptors = [sortDescriptor]
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        
        DispatchQueue.global(qos: .background).async {
            
            allPhotos.enumerateObjects({ (asset, count, stop) in
                
                let imageMenager = PHImageManager.default()
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                let targetSize = CGSize(width: 200, height: 200)
                imageMenager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    
                    if let image = image {
                        
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                        self.images.append(image)
                        self.assets.append(asset)
                    }
                    
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                        
                    }
                })
            })
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
       
        
        selectedImage = images[indexPath.item]
        collectionView.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        
        //collectionView.contentOffset = CGPoint(x: 0, y: -44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    var selectedImage : UIImage?
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
    
    var header : PhotoSelectorHeader?
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeader
        
        self.header = header
        
        if let selImage = selectedImage {
            if let index = self.images.index(of: selImage){
                let selectedAsset = self.assets[index]
                let targetSize = CGSize(width: 600, height: 600)
                let imageMenager = PHImageManager.default()
                imageMenager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                    
                    header.headerImage.image = image
                    
                })
            }
        }
        
        
        
        
        
        return header
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        cell.cellImage.image = images[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width - 2) / 3
        return CGSize(width: size, height: size)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setupNavigationButtons() {
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        
    }
    
    @objc func handleNext(){
        
        let sharedVC = SharePhotoController()
        sharedVC.selectedImage = header?.headerImage.image
        navigationController?.pushViewController(sharedVC, animated: true)
        
         
    }
    
    @objc func handleCancel() {
        print("cancel")
        dismiss(animated: true, completion: nil)
    }
}
