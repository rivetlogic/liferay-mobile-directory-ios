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
    
    // Adds blur style to bg portrait image
    func addBlurStyles(imageView: UIImageView!) {
        var ciContext = CIContext(options: nil)
        var image = CIImage(image: imageView?.image)
        var ciFilter = CIFilter(name: "CIGaussianBlur")
        ciFilter.setValue(image, forKey: kCIInputImageKey)
        
        ciFilter.setValue(8, forKey: "inputRadius")
        var cgImage = ciContext.createCGImage(ciFilter.outputImage, fromRect: image.extent())?
        var blurredImage = UIImage(CGImage: cgImage)!
        
        imageView?.image = blurredImage
        
    }
    
    // Adds image to view and verifies if same image was processed to use a "cached" image instead
//    func addImageToView(imageView: UIImageView!, imageUrl: NSURL!) {
//        print(imageUrl!.description)
//        if let storedImage = self._processedImages.indexForKey(imageUrl!.description) {
//            imageView?.image = self._processedImages[imageUrl!.description]
//            return
//        }
//        
//        let data = NSData(contentsOfURL: imageUrl!)
//        var image = UIImage(data: data!)
//        imageView?.image = image
//        self._processedImages[imageUrl!.description] = image
//
//    }
    
    // add image to view from NSData
    func addImageFromData(imageView: UIImageView!, image: NSData!) {
        var image = UIImage(data: image!)
        imageView?.image = image

    }
    
    // get image data based on image url
    func getImageData(imageUrl: String) -> NSData {
        let url = NSURL(string: imageUrl)
        return NSData(contentsOfURL: url!)!
    }
    
}
