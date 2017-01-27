//
//  HTMLElement.swift
//  HTMLParser
//
//  Created by Chris Larsen on 2016-12-14.
//  Copyright © 2016 Larsen Tech. All rights reserved.
//

import Foundation

class HTMLElement {
    private(set) var name = ""
    private(set) var attributes = [String: String]()
    var children = [HTMLElement]()
    var content: String?
    weak var parent: HTMLElement?
    
    init(element: String) {
        /// Parses an HTML opening tag from the given string, and returns it as an HTMLElement object.
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
                attrName = name.lowercased()
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
        /// Adds a given HTMLElement as a child element.
        self.children.append(child)
    }
    
    func id() -> String? {
        /// Returns the id of the element, or nil if no id exists.
        return self.attributes["id"]
    }
    
    func classes() -> [String]? {
        /// Returns the classes of the element as an array of strings. Returns nil if there are no classes.
        var array: [String]?
        
        if let classes = self.attributes["class"] {
            array = classes.components(separatedBy: " ")
        }
        return array
    }
    
    func simpleDescription(indent: Int) -> String {
        /// Returns a simple description of the HTML element and its children.
        var string = "\(indents(indent))Tag: \(self.name)\n"
        if let content = self.content {
            string += "\(indents(indent))Content: \(content)\n"
        }
        if self.children.count > 0 {
            string += "\(indents(indent))Children:\n"
            for child in self.children {
                string += "\(child.simpleDescription(indent: indent + 1))"
            }
        }
        
        return string
    }
    
    func fullDescription() -> String {
        /// Returns a very detailed description of the HTML element.
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
    
    func indents(_ num: Int) -> String {
        var string = ""
        if num > 0 {
            for _ in 1...num {
                string += "\t"
            }
        }
        
        return string
    }
}
