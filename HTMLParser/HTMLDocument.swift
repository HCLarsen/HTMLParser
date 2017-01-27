//
//  HTMLDoc.swift
//  HTMLParser
//
//  Created by Chris Larsen on 2016-12-21.
//  Copyright © 2016 Larsen Tech. All rights reserved.
//

import Foundation

class HTMLDocument {
    private(set) var doctype = ""
    private(set) var elements: [HTMLElement]

    init(document: String) {
        /// Parses an HTML document from the given string, and returns it as an HTMLDocument object.
        self.elements = []
        var element: HTMLElement
        var parent: HTMLElement?
        let scanner = Scanner(string: document)
        var nsName: NSString?
        var scan: NSString?

        let startCharacters = CharacterSet.alphanumerics.union(["<"])
        let textCharacters = CharacterSet.alphanumerics.union(CharacterSet.whitespaces).union(CharacterSet.punctuationCharacters)
        
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
                        } else if name.hasPrefix("!--") {
                            // Indicates a comment. May or may not record these.
                        } else if name.hasPrefix("![") {
                            // Indicates an IE conditional. Not very useful for purpose of parsing.
                        } else if name.hasPrefix("!") {
                            // Indicates the doctype tag
                            let doctype = name.lowercased()
                            switch doctype {
                            case "!doctype html":
                                self.doctype = "HTML5"
                            case "!doctype html public \"-//w3c//dtd html 4.01//en\" \"http://www.w3.org/tr/html4/strict.dtd\"":
                                self.doctype = "HTML 4.01 Strict"
                            case "!doctype html public \"-//w3c//dtd html 4.01 transitional//en\" \"http://www.w3.org/tr/html4/loose.dtd\"":
                                self.doctype = "HTML 4.01 Transitional"
                            case "!doctype html public \"-//w3c//dtd html 4.01 frameset//en\" \"http://www.w3.org/tr/html4/frameset.dtd\"":
                                self.doctype = "HTML 4.01 Frameset"
                            case "!doctype html public \"-//w3c//dtd xhtml 1.0 strict//en\" \"http://www.w3.org/tr/xhtml1/dtd/xhtml1-strict.dtd\"":
                                self.doctype = "XHTML 1.0 Strict"
                            case "!doctype html public \"-//w3c//dtd xhtml 1.0 transitional//en\" \"http://www.w3.org/tr/xhtml1/dtd/xhtml1-transitional.dtd\"":
                                self.doctype = "XHTML 1.0 Transitional"
                            case "!doctype html public \"-//w3c//dtd xhtml 1.0 frameset//en\" \"http://www.w3.org/tr/xhtml1/dtd/xhtml1-frameset.dtd\"":
                                self.doctype = "XHTML 1.0 Frameset"
                            case "!doctype html public \"-//w3c//dtd xhtml 1.1//en\" \"http://www.w3.org/tr/xhtml11/dtd/xhtml11.dtd\"":
                                self.doctype = "XHTML 1.1"
                            default:
                                self.doctype = "Unknown doctype"
                            }
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
    
    convenience init?(url: URL) {
        do {
            let contents = try String(contentsOf: url)
            self.init(document: contents)
        } catch {
            return nil
        }
    }
    
    func elementsDictionary() -> Dictionary<String, Array<HTMLElement>> {
        /// Returns the document's elements as a dictionary, with tag names as keys, and arrays of corresponding elements as values.
        var elementsDictionary = [String: [HTMLElement]]()
        
        for element in self.elements {
            if elementsDictionary[element.name] != nil {
                elementsDictionary[element.name]?.append(element)
            } else {
                elementsDictionary[element.name] = [element]
            }
        }
        
        return elementsDictionary
    }
    
    func elementsByName(name: String) -> [HTMLElement]? {
        /// Returns an optional array of elements of the specified name. For example:
        ///
        ///         html.elementsByName("img")
        ///
        /// This will return all the img elements in the document.
        ///
        /// Note:   The name parameter is case sensitive.
        var elements = self.elementsDictionary()
        return elements[name]
    }

    func firstElementByName(name: String) -> HTMLElement? {
        /// Similar to elementsByName, but only returns the first element found. Useful when looking for html, body, doctype, or such tags where there will be only one.
        var elements = self.elementsDictionary()
        return elements[name]?.first
    }
    
    func plainText() -> String {
        /// Returns a plain text representation of the contents of the webpage.
        var string = "Plain Text representation of this webpage."
        string += "Test text"
        return string
    }

    func simpleDescription() -> String {
        /// Returns a small description of the webpage.
        var string = ""
        if self.elements.count > 0 {
            string += "Document has \(self.elements.count) elements\n"
        }
        return string
    }
    
    func fullDescription() -> String {
        /// Returns a full description of the webpage, with basic information about all elements.
        var string = ""
        if self.elements.count > 0 {
            string += "Document has \(self.elements.count) elements\n"
            string += "Doctype: \(doctype)\n"
            if let html = self.firstElementByName(name: "html") {
                string += html.simpleDescription(indent: 0)
            }
        }
        return string
    }
}


