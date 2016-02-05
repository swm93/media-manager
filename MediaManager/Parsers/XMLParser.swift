//
//  XMLParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-20.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation


class XMLParser : APIParser, NSXMLParserDelegate
{
    internal var rootNode:[NSXMLParser: XMLNode] = [NSXMLParser: XMLNode]()
    private var currentNode:[NSXMLParser: XMLNode] = [NSXMLParser: XMLNode]()
    
    
    override internal func parse(data:NSData?, response:NSURLResponse?, error:NSError?)
    {
        if let d:NSData = data
        {
            let parser:NSXMLParser = NSXMLParser(data: d)
            parser.delegate = self
            
            parser.parse()
        }
    }
    
    
    func parserDidStartDocument(parser: NSXMLParser)
    {
        rootNode.removeValueForKey(parser)
        currentNode.removeValueForKey(parser)
    }
    
    
    func parserDidStopDocument(parser: NSXMLParser, mediaObject: Media?)
    {
        rootNode.removeValueForKey(parser)
        currentNode.removeValueForKey(parser)
        
        didFinishParsing(mediaObject)
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if (currentNode[parser]?.value == nil)
        {
            currentNode[parser]?.value = ""
        }
        
        currentNode[parser]?.value! += string
    }
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String])
    {
        let node:XMLNode = XMLNode(parent: currentNode[parser], attributes: attributeDict)
        
        if let cNode:XMLNode = currentNode[parser]
        {
            if (cNode[elementName] == nil)
            {
                cNode[elementName] = [XMLNode]()
            }
            
            cNode[elementName]?.append(node)
        }
        else
        {
            rootNode[parser] = node
        }
        
        currentNode[parser] = node
    }
    
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        currentNode[parser] = currentNode[parser]?.parent
    }
}