import Cocoa

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

var element = ""

element = "<div class=\"w3-main w3-light-grey\" id=\"belowtopnav\" style=\"margin-left: 220px; padding-top: 0px;\">"
element = element.trimmingCharacters(in: ["<", ">"])
var htmlElement = HTMLElement(element: element)
print(htmlElement.name)
print(htmlElement.attributes)
if htmlElement.attributes.count != 3 {
    print("Element 1 Not working")
}

element = "<a title=\"Read our blog!\" href=\"blog.htm\" hidden class=\"title blog\" >"
element = element.trimmingCharacters(in: ["<", ">"])
var htmlElement2 = HTMLElement(element: element)
print(htmlElement2.name)
print(htmlElement2.attributes)
if htmlElement2.attributes.count != 4 {
    print("Element 2 Not working")
}

