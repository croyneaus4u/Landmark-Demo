//
//  DataModel.swift
//  LandmarkDemo
//
//  Created by Lab kumar on 10/11/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import Foundation
import HTMLReader

extension String {
    func textByTrimming () -> String {
        let text = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return text
    }
}

class Container: NSObject {
    var title: String?
    var items: [Item]?
}

class Item: NSObject {
    var title: String?
    var subTitle: String?
    var imageURL: String?
    var priceString: String?
}

class Parser {
    class func parseServerData (document: HTMLDocument) -> [Container]? {
        guard let nodes = document.firstNode(matchingSelector: "div[class='intro-area']")?.nodes(matchingSelector: "div[class='block']") else {
            return nil
        }
        
        var dataSource = [Container]()
        for node in nodes {
            let containerData = Container()
            
            let header = node.firstNode(matchingSelector: "header")
            let value = header?.textContent.textByTrimming()
            containerData.title = value
            
            if let productNode = node.firstNode(matchingSelector: "ul[class='products']") {
                containerData.items = arrayOfProductsForNode(node: productNode)
            }
            
            dataSource.append(containerData)
        }
        
        return dataSource
    }
    
    class func arrayOfProductsForNode (node: HTMLNode) -> [Item] {
        let element = node.nodes(matchingSelector: "li[class='product-item']")
        var itemArray = [Item]()
        for product in element {
            let item = Item()
            
            item.imageURL = product.firstNode(matchingSelector: "img")?.attributes["src"]
            item.title = product.firstNode(matchingSelector: "span")?.textContent.textByTrimming()
            item.subTitle = product.firstNode(matchingSelector: "span[itemprop='name']")?.textContent.textByTrimming()
            item.priceString = product.firstNode(matchingSelector: "span[itemprop='price']")?.textContent.textByTrimming()
            
            itemArray.append(item)
        }
        
        return itemArray
    }
}

