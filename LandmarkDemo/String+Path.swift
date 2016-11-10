//
//  String+Path.swift
//  LandmarkDemo
//
//  Created by Lab kumar on 10/11/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import Foundation

extension String {
    
    func documentPath() -> String {
        let path = NSSearchPathForDirectoriesInDomains( .documentDirectory, .userDomainMask, true).last
        let nsPath: NSString = path! as NSString
        let nsSelf: NSString = self as NSString
        return nsPath.appendingPathComponent(nsSelf.lastPathComponent)
    }
    
    func cachesPath() -> String {
        let path = NSSearchPathForDirectoriesInDomains( .cachesDirectory, .userDomainMask, true).last
        let nsPath: NSString = path! as NSString
        let nsSelf: NSString = self as NSString
        return nsPath.appendingPathComponent(nsSelf.lastPathComponent)
    }
    
    func tempPath() -> String {
        let path: NSString = NSTemporaryDirectory() as NSString
        let nsSelf: NSString = self as NSString
        return path.appendingPathComponent(nsSelf.lastPathComponent)
    }
}
