//
//  ImageDownloadOperation.swift
//  LandmarkDemo
//
//  Created by Lab kumar on 10/11/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import UIKit

class ImageDownloadOperation: Operation {
    
    var path: String?
    var  completion: ((UIImage) -> Void)?
    
    class func operationWith(_ path: String , completion: @escaping (_ image:UIImage) -> ()) -> ImageDownloadOperation {
        let op = ImageDownloadOperation()
        op.path = path
        op.completion = completion
        
        return op
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        var image: UIImage?
        if path != nil {
            guard let url = URL(string: path!) else {
                return
            }
            let data = try? Data(contentsOf: url)
            
            if (self.isCancelled) {return}
            
            if let imageData = data {
                image = UIImage(data: imageData)
                try? imageData.write(to: URL(fileURLWithPath: path!.cachesPath()), options: [.atomic])
            } else {
                print("error")
            }
        }
        
        if (self.isCancelled) {return}
        if completion != nil && image != nil{
            OperationQueue.main.addOperation({ () -> Void in
                self.completion!(image!)
            })
            
        }
    }
    
   
   
}
