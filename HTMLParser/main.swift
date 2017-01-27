//
//  main.swift
//  HTMLParser
//
//  Created by Chris Larsen on 2016-12-14.
//  Copyright © 2016 Larsen Tech. All rights reserved.
//

import Foundation

var document = "<!DOCTYPE html>\n<html>\n<head>\n<meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width\"><title>JS Bin</title></head><body><div class=\"some-style\"><img id=\"image\" src=\"image.jpg\" /><p>hi you so <b>BOLD!</b></p><p hidden>HUH</p></div></body></html>"

var html: HTMLDocument? = HTMLDocument(document: document)
//print(html.fullDescription())
if let doc = html {
    print(doc.elements.count)
}

html = nil

/*var html2 = HTMLDocument(document: "")
print(html2.fullDescription())*/

/*if let url = URL(string: "https://www.duckduckgo.com") {
    if var html3 = HTMLDocument(url: url) {
        // print(html3.fullDescription())
        print(html3.elementsByName(name: "form")!.first)
        
    }
}*/
