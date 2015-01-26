//
//  ImageHelper.swift
//  MobilePeopleDirectory
//
//  Created by alejandro soto on 1/24/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit
import Foundation

class ImageHelper: NSObject {
    
    private var _processedImages = [String: UIImage]()
    
    // Adds styles to list thubmnails
    func addThumbnailStyles(imageView: UIImageView!) {
    
        imageView?.layer.cornerRadius = 30.0
        imageView?.layer.masksToBounds = true
        imageView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        imageView?.layer.borderWidth = 1.0
        
    }
    
    // Adds image to view and verifies if same image was processed to use a "cached" image instead
    func addImageToView(imageView: UIImageView!, imageUrl: NSURL!) {
        
        if let storedImage = self._processedImages.indexForKey(imageUrl!.description) {
            imageView?.image = self._processedImages[imageUrl!.description]
            return
        }
        
        let data = NSData(contentsOfURL: imageUrl!)
        var image = UIImage(data: data!)
        imageView?.image = image
        self._processedImages[imageUrl!.description] = image

    }
    
}
