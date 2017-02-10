//
//  Parsable.swift
//  Parsable
//
//  Created by Jo Albright on 1/1/16.
//  Copyright © 2016 Jo Albright. All rights reserved.
//

import Foundation

public typealias ParsedInfo = [String:Any]
public typealias ParseOptionalInfo = [String:Any?]

public protocol Parsable: Inlinit {
    
    init(_:ParsedInfo)
    
}

extension Parsable {
    
    public func parse() -> ParsedInfo {
        
        return ParsedInfo {
            
            for c in Mirror(reflecting: self).children {
                
                guard let label = c.label else { continue }
                c.value --> $0[label]
                
            }
            
        }
        
    }
    
}

infix operator <--
infix operator -->

// MARK: Parsable - Operators

public func <-- <T:Parsable>(left:inout T?, right: Any?) { left = T(right as? ParsedInfo ?? [:]) }
public func --> <T:Parsable>(left:T?, right: inout Any?) { right = left?.parse() }

public func <-- <T:Parsable>(left:inout T, right: Any?) { left = T(right as? ParsedInfo ?? [:]) }
public func --> <T:Parsable>(left:T, right: inout Any?) { right = left.parse() }

// MARK: Parsable - Array Operators

public func <-- <T:Parsable>(left:inout [T], right: Any?) { left = (right as? [ParsedInfo])?.parse() ?? [] }
public func --> <T:Parsable>(left:[T], right: inout Any?) { right = left.parse() }

// MARK: Parsable - Basic Type Operators

public func <-- <T>(left:inout T?, right: Any?) { left = right as? T }
public func --> <T>(left:T?, right: inout Any?) { right = left }

public func <-- <T>(left:inout T, right: Any?) { left = right as? T ?? left }
public func --> <T>(left:T, right: inout Any?) { right = left }

// MARK: Parsable - Extensions

public extension Array where Element: Parsable {
    
    public func parse() -> [ParsedInfo] {
        
        return [ParsedInfo] { for item in self { $0.append(item.parse()) } }
        
    }
    
}

public extension Collection where Iterator.Element == ParsedInfo {
    
    public func parse<T:Parsable>() -> [T] {
        
        return [T] { for item in self { $0.append(T(item)) } }
        
    }
    
}

