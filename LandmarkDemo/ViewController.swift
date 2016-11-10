//
//  ViewController.swift
//  LandmarkDemo
//
//  Created by Lab kumar on 10/11/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import UIKit
import HTMLReader

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var requestor = BaseRequestor()
    
    var dataSource: [Container]? {
        didSet {
            collectionView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        
        getData()
    }
    
    func getData () {
        requestor.makeGETRequestWithparameters(urlString: "http://www.landmarkshops.com", success: { [weak self] (result) in
            //print(result ?? "")
            let document = HTMLDocument(string: result as! String)
            self?.createDataSource(document: document)
            }, failure: { (error) in
                //
        })
    }
    
    func createDataSource (document: HTMLDocument) {
        dataSource = Parser.parseServerData(document: document)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate let cellId = "cellId"
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        cell.dataSource = dataSource?[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }

}

