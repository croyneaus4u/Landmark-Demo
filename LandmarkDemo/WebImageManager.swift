//
//  WebImageManager.swift
//  LandmarkDemo
//
//  Created by Lab kumar on 10/11/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import UIKit

class WebImageManager: NSObject {
    
    let queue = OperationQueue()
    var imageCache = NSCache<AnyObject, AnyObject>()
    var operationCache = NSMutableDictionary()
    
    static let sharedInstance : WebImageManager = {
        let instance = WebImageManager()
        return instance
    }()
    
    fileprivate override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(WebImageManager.receviMomeryWorning), name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    func cancelOperation(_ path: String){
        
        if let op = self.operationCache[path] as? Operation{
            op.cancel()
            operationCache.removeObject(forKey: path)
        }
    }
    
    func downloadWebImage(_ path: String, completion: @escaping (_ image: UIImage) -> ()){
        
        if let ime = imageCache.object(forKey: path as AnyObject) as? UIImage {
            completion(ime)
            return
        }
        
        let imagePath = path.cachesPath()
        if let ime = UIImage(contentsOfFile: imagePath) {
            completion(ime)
            imageCache.setObject(ime, forKey: path as AnyObject)
            
            return
        }
        
        if let _ = self.operationCache[path] as? Operation {
            return
        }
        
        let op = ImageDownloadOperation.operationWith(path, completion: { (image) -> () in
            self.operationCache.removeObject(forKey: path)
            self.imageCache.setObject(image, forKey: path as AnyObject)
            completion(image)
        })
        
        operationCache.setValue(op, forKey: path)
        queue.addOperation(op)
    }
    
    func receviMomeryWorning() {
        imageCache.removeAllObjects()
        operationCache.removeAllObjects()
    }
}
