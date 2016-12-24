import Cocoa

var doc = "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width\"><title>JS Bin</title></head><body><div class=\"some-style\"><img src=\"image.jpg\" /><p>hi you so <b>BOLD!</b></p><p>HUH</p></div></body></html>"

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
            //print("Tag: \(name)")
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
            
            //print("Name: \(attrName)")
            //print("Value \(attrValue)")
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

/*var element = HTMLElement(element: "<meta name=\"viewport\" content=\"width=device-width\">")

var element2 = HTMLElement(element: "<img src=\"image.jpg\" />")

var element3 = HTMLElement(element: "<div id=\"test\" class=\"test class\" hidden >")*/

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
                            //print("Closing Tag " + name)
                            if let currentParent = parent {
                                parent = currentParent.parent
                            }
                        } else if name.hasPrefix("!") {
                            //print("Doctype Tag " + name)
                            self.elements.append(HTMLElement(element: name))
                        } else {
                            //print("Opening Tag " + name)
                            element = HTMLElement(element: name)
                            if let currentParent = parent {
                                currentParent.addChild(child: element)
                                element.parent = currentParent
                            }
                            self.elements.append(element)
                            if element.name != "meta" && !name.hasSuffix("/") {
                                // meta tags are self closing, but lack the /> closing
                                parent = element
                            }
                        }
                    }
                }
            } else if scanner.scanCharacters(from: textCharacters, into: &scan) {
                if let content = scan as String?, let currentParent = parent {
                    //print("Content " + content)
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
}

var html = HTMLDoc(document: doc)
var i = 7

print(html.simpleDescription())
print(html.elements[i].fullDescription())
html.elements.count
print(html.elements[0].attributes)

