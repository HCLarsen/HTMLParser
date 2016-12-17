//
//  HTMLElement.swift
//  HTMLParser
//
//  Created by Chris Larsen on 2016-12-14.
//  Copyright © 2016 Larsen Tech. All rights reserved.
//

import Foundation

class HTMLElement {
    var name = ""
    var content: String?
    var attributes = [String: String]()
    var children = [HTMLElement]()
    var parent: HTMLElement?
    
    init(element: String) {
        // Parses the string of the opening tag and processes attributes
        let stringScanner = Scanner(string: element)
        var nsName: NSString?
        var attrName: String
        var attrValue: String
        
        stringScanner.scanUpTo(" ", into: &nsName)
        if let name = nsName {
            self.name = name as String
        }
        
        var key = 0
        while !stringScanner.isAtEnd {
            key += 1
            attrName = ""
            attrValue = ""
            
            let array = Array(element.unicodeScalars)
            var string = ""
            for i in stringScanner.scanLocation+1..<element.characters.count {
                string += String(array[i])
            }
            string = string.trimmingCharacters(in: [" "])
            if string.isEmpty {
                break
            }
            if let space = string.characters.index(of: " "), let equal = string.characters.index(of: "=") {
                if equal < space {
                    stringScanner.scanUpTo("=", into: &nsName)
                    if let name = nsName {
                        attrName = name.trimmingCharacters(in: ["\"", " "])
                    }
                    
                    stringScanner.scanUpTo("\"", into: &nsName) // Skipping over the opening quote
                    stringScanner.scanUpTo("\" ", into: &nsName)
                    if let value = nsName {
                        attrValue = value.trimmingCharacters(in: ["\"", " "])
                    }
                } else {
                    // boolean attributes have no value, different logic is required
                    stringScanner.scanUpTo(" ", into: &nsName)  // Skipping over the space before the boolean attribute
                    stringScanner.scanUpTo(" ", into: &nsName)
                    if let name = nsName {
                        attrName = name.trimmingCharacters(in: ["\"", " "])
                    }
                    attrValue = ""
                }
                attrValue += String(key)
                self.attributes[attrName] = attrValue
            }
            
        }
    }
    
    func addChild(child: HTMLElement) {
        
    }
    
    func setParent(parent: HTMLElement) {
        self.parent = parent
    }
}
