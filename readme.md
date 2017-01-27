HTML Parser

By Chris Larsen

A simple HTML parser written in Swift.

Classes

HTMLElement

This class represents each HTML element in the document. The tag is represented as a string, the attributes are a document with strings as keys, and an array of strings as the value. There is also an array of children, and a single parent HTMLElement.

HTMLDocument

This class represents an entire HTML document. It is initialized from HTML code as a string, and contains methods for determining details of the HTML document.

