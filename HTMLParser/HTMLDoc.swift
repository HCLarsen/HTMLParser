//
//  HTMLDoc.swift
//  HTMLParser
//
//  Created by Chris Larsen on 2016-12-21.
//  Copyright © 2016 Larsen Tech. All rights reserved.
//

import Foundation

class HTMLDoc {
    var startCharacters = CharacterSet.alphanumerics.union(["<"])
    var textCharacters = CharacterSet.alphanumerics.union(CharacterSet.whitespaces).union(CharacterSet.punctuationCharacters)
    var endCharacters = CharacterSet.newlines.union([">"])
    
    var elements: [HTMLElement]
    var nsName: NSString?
    var scan: NSString?
    
    init(document: String) {
        self.elements = []
        var element: HTMLElement
        var parent: HTMLElement?
        let scanner = Scanner(string: document)
        
        while !scanner.isAtEnd {
            scanner.scanUpToCharacters(from: startCharacters, into: &nsName)
            if scanner.scanCharacters(from: ["<"], into: &scan){
                if scan != nil {
                    scanner.scanUpToCharacters(from: [">"], into: &nsName)
                    if let name = nsName as String? {
                        if name.hasPrefix("/") {
                            if let currentParent = parent {
                                parent = currentParent.parent
                            }
                        } else if name.hasPrefix("!") {
                            self.elements.append(HTMLElement(element: name))
                        } else {
                            element = HTMLElement(element: name)
                            if let currentParent = parent {
                                currentParent.addChild(child: element)
                                element.parent = currentParent
                            }
                            self.elements.append(element)
                            if element.name != "meta" && !name.hasSuffix("/") {
                                // meta tags are self closing, but lack the /> end
                                parent = element
                            }
                        }
                    }
                }
            } else if scanner.scanCharacters(from: textCharacters, into: &scan) {
                if let content = scan as String?, let currentParent = parent {
                    currentParent.content = content
                }
            }
        }
    }
    
    func simpleDescription() -> String {
        var string = ""
        if self.elements.count > 0 {
            string += "Document has \(self.elements.count) elements\n"
        }
        return string
    }
    
    func fullDescription() -> String {
        var string = ""
        if self.elements.count > 0 {
            string += "Document has \(self.elements.count) elements\n"
            if self.elements[0].attributes.keys.contains("html") {
                string += "Doctype: HTML\n"
            }
            string += self.elements[1].simpleDescription(indent: 0)
        }
        return string
    }
}


