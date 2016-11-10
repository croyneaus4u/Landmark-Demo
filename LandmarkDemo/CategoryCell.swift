//
//  CategoryCell.swift
//  LandmarkDemo
//
//  Created by Lab kumar on 10/11/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "ProductCellId"
    
    var dataSource: Container? {
        didSet {
            nameLabel.text = dataSource?.title
            productsCollectionView.reloadData()
            paginator.numberOfPages = (dataSource?.items?.count ?? 1)/2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Avenir-Heavy", size: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let paginator: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        
        pageControl.currentPageIndicatorTintColor = UIColor.init(red: 36/255.0, green: 155/255.0, blue: 180/255.0, alpha: 1.0)
        pageControl.pageIndicatorTintColor = UIColor.init(red: 199/255.0, green: 203/255.0, blue: 211/255.0, alpha: 1.0)
        
        return pageControl
    }()
    
    func setupViews() {
        backgroundColor = UIColor.clear
        
        addSubview(productsCollectionView)
        addSubview(dividerLineView)
        addSubview(nameLabel)
        addSubview(paginator)
        
        productsCollectionView.dataSource = self
        productsCollectionView.delegate = self
        
        productsCollectionView.register(ProductCell.self, forCellWithReuseIdentifier: cellId)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(padding))-[nameLabel]|", options: [], metrics: nil, views: ["nameLabel": nameLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dividerLineView]|", options: [], metrics: nil, views: ["dividerLineView": dividerLineView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[productsCollectionView]|", options: [], metrics: nil, views: ["productsCollectionView": productsCollectionView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[paginator]|", options: [], metrics: nil, views: ["paginator": paginator]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel(50)][productsCollectionView][paginator][dividerLineView(0.5)]|", options: [], metrics: nil, views: ["productsCollectionView": productsCollectionView, "dividerLineView": dividerLineView, "nameLabel": nameLabel, "paginator": paginator]))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProductCell
        
        let itemData = dataSource?.items?[indexPath.row]
        
        cell.nameLabel.text = itemData?.title
        cell.categoryLabel.text = itemData?.subTitle
        cell.priceLabel.text = itemData?.priceString
        cell.imageView.setWebImage(itemData?.imageURL ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/2.0 - padding, height: frame.height - 32)
    }
    
    let padding: CGFloat = 15
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, padding, 0, padding)
    }
    
    // MARK:- Scroll delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let pageNum: Int = Int(x / scrollView.frame.size.width)
        
        if(paginator.currentPage != pageNum) {
            paginator.currentPage = pageNum
        }
    }
    
}

class ProductCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Avenir-Book", size: 15.0)
        label.numberOfLines = 1
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.init(name: "Avenir-Book", size: 13.0)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Avenir-Medium", size: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        return label
    }()
    
    func setupViews() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(priceLabel)
        
        let views = ["imageView": imageView, "nameLabel": nameLabel, "categoryLabel": categoryLabel, "priceLabel": priceLabel]
        
        let visualConstraints = [
            "H:|[imageView]|",
            "V:|-[imageView]-[nameLabel]-[categoryLabel]-[priceLabel]-(>=8)-|",
            "H:|[nameLabel]|",
            "H:|[categoryLabel]|",
            "H:|[priceLabel]|"]
        
        let constraints = getVisualConstraintArray(vcArray: visualConstraints, options: [], metrics: nil, viewDictionary: views)
        addConstraints(constraints)
        
        let imageHeightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0)
        addConstraint(imageHeightConstraint)
        
    }
    
    func getVisualConstraintArray(vcArray: [String], options opts: NSLayoutFormatOptions, metrics: [String: AnyObject]?,
                                  viewDictionary: [String: AnyObject]) -> [NSLayoutConstraint] {
        var result = [NSLayoutConstraint]()
        for visualConstraint in vcArray {
            let newConstraints = NSLayoutConstraint.constraints(withVisualFormat: visualConstraint,
                                                                options: opts, metrics: metrics, views: viewDictionary)
            result += newConstraints
        }
        return result
    }
    
}





