//
//  main.swift
//  HTMLParser
//
//  Created by Chris Larsen on 2016-12-14.
//  Copyright © 2016 Larsen Tech. All rights reserved.
//

import Foundation

var document = "<!DOCTYPE html>\n<html>\n<head>\n<meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width\"><title>JS Bin</title></head><body><div class=\"some-style\"><img src=\"image.jpg\" /><p>hi you so <b>BOLD!</b></p><p hidden>HUH</p></div></body></html>"

var html = HTMLDocument(document: document)
print(html.fullDescription())
