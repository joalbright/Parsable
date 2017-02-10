//
//  Savable.swift
//  Encodable
//
//  Created by Jo Albright on 1/6/16.
//
//

import Foundation

private let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first

public protocol Saveable { }

extension Saveable {
    
    public func save(_ name: String, info: Any?) {
        
        guard let info = info else { return }
        guard let directory = documentDirectory else { return }
        
        let path = directory + "/" + name
        
        DispatchQueue.global().async { NSKeyedArchiver.archiveRootObject(info, toFile: path) }
        
    }
    
    public func load(_ name: String, completion: @escaping (Any?) -> ()) {
        
        guard let directory = documentDirectory else { return }
        
        let path = directory + "/" + name
        
        DispatchQueue.global().async {
            
            let data = NSKeyedUnarchiver.unarchiveObject(withFile: path)
            
            DispatchQueue.main.async { completion(data) }
            
        }
        
    }
    
}




