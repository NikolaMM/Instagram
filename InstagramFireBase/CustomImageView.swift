//
//  CustomImageView.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/18/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit

var imageCache = [String:UIImage]()

class CustomImageView: UIImageView {
    
    var lastUrlUsedToLoadImage : String?
    
    func loadImage(urlString: String){
        
        lastUrlUsedToLoadImage = urlString
        
        self.image = nil
        
        if let cacheImage = imageCache[urlString] {
            
            self.image = cacheImage
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            if let err = err {
                print("Faild to fetch posts" , err)
            }
            
            if url.absoluteString != self.lastUrlUsedToLoadImage {
                return
            }
            
            guard let imageDada = data else { return }
            let photoImage = UIImage(data: imageDada)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
    }
}
