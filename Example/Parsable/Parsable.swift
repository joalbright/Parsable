//
//  Parsable.swift
//  Parsable
//
//  Created by Jo Albright on 1/1/16.
//  Copyright © 2016 Jo Albright. All rights reserved.
//

import Foundation


public typealias ParsedInfo = [String:Any]
public typealias ParsedOptionalInfo = [String:Any?]

public protocol Parsable { init(_:ParsedInfo) }

extension Parsable {
    
    public func parse() -> ParsedInfo {
        
        return parse(Mirror(reflecting: self))
        
    }
    
    public func parseOptional() -> ParsedOptionalInfo {
        
        return parseOptional(Mirror(reflecting: self))
        
    }
    
    public func parse(_ object: Mirror?) -> ParsedInfo {
        
        guard let object = object else { return [:] }
        
        var info = parse(object.superclassMirror)
        
        for property in object.children {
            
            guard let label = property.label else { continue }
            
            guard let value = unwrap(property.value) else { continue }
            
            if let v = value as? [Any] {
                
                let flattened = v.flatMap { ($0 as? Parsable)?.parse() }.filter { !$0.isEmpty }
                guard !flattened.isEmpty else { continue }
                info[label] <-- flattened
                
            } else if let v = value as? Parsable {
                
                guard !v.parse().isEmpty else { continue }
                info[label] <-- v.parse()
                
            } else {
                
                info[label] <-- value
                
            }
            
        }
        
        return info
        
    }
    
    public func parseOptional(_ object: Mirror?) -> ParsedOptionalInfo {
        
        guard let object = object else { return [:] }
        
        var info = parseOptional(object.superclassMirror)
        
        for property in object.children {
            
            guard let label = property.label else { continue }
            
            info[label] = nil
            
            guard let value = unwrap(property.value) else { continue }
            
            if let v = value as? [Any] {
                
                let flattened = v.flatMap { ($0 as? Parsable)?.parseOptional() }.filter { !$0.isEmpty }
                guard !flattened.isEmpty else { continue }
                info[label] <-- flattened
                
            } else if let v = value as? Parsable {
                
                guard  !v.parseOptional().isEmpty else { continue }
                info[label] <-- v.parse()
                
            } else {
                
                info[label] <-- value
                
            }
            
        }
        
        return info
        
    }
    
    func unwrap(_ object: Any) -> Any? {
        
        let mirror = Mirror(reflecting: object)
        
        guard mirror.displayStyle == .optional else { return object }
        guard let firstChild = mirror.children.first else { return nil }
        
        return unwrap(firstChild.value)
        
    }
    
    public func parseWith(_ keys: [String]) -> ParsedInfo {
        
        return parse().reduce([:]) { keys.contains($0.1.0) ? $0.0 + [$0.1.0:$0.1.1] : $0.0 }
        
    }
    
    public func parseWithout(_ keys: [String]) -> ParsedInfo {
        
        return parse().reduce([:]) { !keys.contains($0.1.0) ? $0.0 + [$0.1.0:$0.1.1] : $0.0 }
        
    }
    
    public func parseOptionalWith(_ keys: [String]) -> ParsedOptionalInfo {
        
        return parseOptional().reduce([:]) { keys.contains($0.1.0) ? $0.0 + [$0.1.0:$0.1.1] : $0.0 }
        
    }
    
    public func parseOptionalWithout(_ keys: [String]) -> ParsedOptionalInfo {
        
        return parseOptional().reduce([:]) { !keys.contains($0.1.0) ? $0.0 + [$0.1.0:$0.1.1] : $0.0 }
        
    }
    
}

// + functions

public func +(lhs:ParsedInfo, rhs: ParsedInfo) -> ParsedInfo {
    
    var combined = lhs
    for (k,v) in rhs { combined[k] = v }
    return combined
    
}

public func +(lhs: ParsedOptionalInfo, rhs: ParsedOptionalInfo) -> ParsedOptionalInfo {
    
    var combined = lhs
    for (k,v) in rhs { combined[k] = v }
    return combined
    
}

// Array & Collection Extensions

public extension Collection where Self.Iterator.Element: Parsable {
    
    public func parse() -> [ParsedInfo] {
        
        return self.map { $0.parse() }
        
    }
    
    public func parseWith(_ keys: [String]) -> [ParsedInfo] {
        
        return self.map { $0.parseWith(keys) }
        
    }
    
    public func parseWithout(_ keys: [String]) -> [ParsedInfo] {
        
        return self.map { $0.parseWithout(keys) }
        
    }
    
    public func parseOptional() -> [ParsedOptionalInfo] {
        
        return self.map { $0.parseOptional() }
        
    }
    
    public func parseWith(_ keys: [String]) -> [ParsedOptionalInfo] {
        
        return self.map { $0.parseOptionalWith(keys) }
        
    }
    
    public func parseWithout(_ keys: [String]) -> [ParsedOptionalInfo] {
        
        return self.map { $0.parseOptionalWithout(keys) }
        
    }
    
}
