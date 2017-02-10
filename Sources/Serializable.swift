//
//  Serializable.swift
//  Parsable
//
//  Created by Jo Albright on 1/9/16.
//
//

import Foundation

// MARK: Serializable

public enum SerializeError: Error { case notSerializable }

public protocol Serializable { }

extension Serializable {
    
    public func serialize(_ object: Any? = nil) throws -> Data {
        
        guard let object = object else { throw SerializeError.notSerializable }
        
        var data: Data
        
        do {  data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            
        } catch { throw error }
        
        return data
        
    }
    
}

extension Array: Serializable { }
extension Dictionary: Serializable { }

// MARK: Unserializable

public enum UnserializeError: Error { case notUnserializable }

public protocol Unserializable { }

extension Unserializable {

    public func unserialize(_ data: Data? = nil) throws -> Any {
        
        guard let data = data ?? self as? Data else { throw UnserializeError.notUnserializable }
        
        var object: Any
        
        do {  object = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
        } catch { throw error }
        
        return object
        
    }
    
}

extension Data: Unserializable { }



