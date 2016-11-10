//
//  UIImageView+WebImage.swift
//  LandmarkDemo
//
//  Created by Lab kumar on 10/11/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import Foundation
import UIKit


private var xoAssociationKey: String = "test.com.WebImage"

extension UIImageView {
   
    var urlParh: String?{
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? String
        }
        
        set {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    func setWebImage(_ path: String){
        image = nil
        let _path = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if urlParh != nil && urlParh != _path {
            WebImageManager.sharedInstance.cancelOperation(urlParh!)
        }
        
        urlParh = _path
        WebImageManager.sharedInstance.downloadWebImage(urlParh!, completion: { (image) -> () in
            self.image = image
            self.urlParh = nil
        })
    }
}
