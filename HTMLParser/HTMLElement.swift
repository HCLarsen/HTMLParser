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
    var attributes = [String: String]()
    var children = [HTMLElement]()
    var content: String?
    var parent: HTMLElement?
    
    init(element: String) {
        // Parses the string of the opening tag and processes attributes
        let scanner = Scanner(string: element.trimmingCharacters(in: ["<", ">", "/"]))
        var nsName: NSString?
        var attrName: String
        var attrValue: String
        let alphaCharacters = CharacterSet.alphanumerics
        
        scanner.scanUpTo(" ", into: &nsName)
        if let name = nsName {
            self.name = name as String
        }
        
        var key = 0
        while !scanner.isAtEnd {
            key += 1
            attrName = ""
            attrValue = ""
            
            scanner.scanUpToCharacters(from: alphaCharacters, into: &nsName)
            scanner.scanCharacters(from: alphaCharacters, into: &nsName)
            if let name = nsName as String? {
                attrName = name
            }
            
            if scanner.scanCharacters(from: ["="], into: &nsName) {
                scanner.scanCharacters(from: ["\""], into: &nsName)
                scanner.scanUpToCharacters(from: ["\""], into: &nsName)
                if let value = nsName {
                    attrValue = value.trimmingCharacters(in: ["\"", " "])
                }
                scanner.scanCharacters(from: ["\""], into: &nsName)
            } else {
                attrValue = ""
            }
            
            self.attributes[attrName] = attrValue
        }
    }
    
    func addChild(child: HTMLElement) {
        self.children.append(child)
    }
    
    func fullDescription() -> String {
        var string = "Tag: \(self.name)\n"
        if let parent = self.parent {
            string += "Parent: \(parent.name)\n"
        }
        if let content = self.content {
            string += "Content: \(content)\n"
        }
        if self.attributes.count > 0 {
            var attributeString = "Attributes: \n"
            for attribute in attributes {
                attributeString += "\t\(attribute.key): \(attribute.value)\n"
            }
            string += attributeString
        }
        if self.children.count > 0 {
            string += "Child elements:\n"
            for child in self.children {
                string += "\t\(child.name)\n"
            }
        }
        
        return string
    }
}
