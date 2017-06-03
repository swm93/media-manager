//
//  XMLParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-20.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation


class XMLParser<T> : APIParser<T>, XMLParserDelegate
{
    internal var rootNode:XMLNode? = nil
    internal var currentNode:XMLNode? = nil
    
    
    
    override internal func parse(_ data:Data?, response:URLResponse?, error:Error?)
    {
        if let d:Data = data
        {
            let parser:Foundation.XMLParser = Foundation.XMLParser(data: d)
            parser.delegate = self
            
            parser.parse()
        }
    }
    
    
    internal func objectifyXML(_ rootNode:XMLNode)
    {
        assert(false, "This method must be overridden")
    }

    
    func parser(_ parser: Foundation.XMLParser, foundCharacters string: String)
    {
        if (currentNode?.value == nil)
        {
            currentNode?.value = ""
        }
        
        currentNode?.value! += string
    }
    
    
    func parser(_ parser: Foundation.XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        let node:XMLNode = XMLNode(parent: currentNode, attributes: attributeDict)
        
        if let cNode:XMLNode = currentNode
        {
            if (cNode[elementName] == nil)
            {
                cNode[elementName] = [XMLNode]()
            }
            
            cNode[elementName]?.append(node)
        }
        else
        {
            rootNode = node
        }
        
        currentNode = node
    }
    
    
    func parser(_ parser: Foundation.XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        currentNode = currentNode?.parent
    }
    
    
    func parserDidEndDocument(_ parser: Foundation.XMLParser)
    {
        if let node:XMLNode = rootNode
        {
            objectifyXML(node)
        }
    }
}
