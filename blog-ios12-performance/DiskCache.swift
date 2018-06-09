//
//  DiskCache.swift
//  blog-ios12-performance
//
//  Created by ttillage on 6/8/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import Foundation

struct DiskCache {
    
    static func save<T: Encodable>(model: T, key: String) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(model)
            let dirURL = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let writeURL = dirURL.appendingPathComponent("\(key).json")
            try data.write(to: writeURL)
            print("Saved \(type(of: model)) to \(writeURL.absoluteString)")
        } catch let e {
            print("\(e)")
        }
    }
    
    static func loadAll<T: Decodable>(type: T.Type) -> [T] {
        do {
            let dirURL = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let keys: [URLResourceKey] = [.isDirectoryKey]
            let paths = try FileManager.default.contentsOfDirectory(at: dirURL, includingPropertiesForKeys: keys, options: [])
            
            var modelData: [Data] = []
            for path in paths {
                if try path.resourceValues(forKeys: Set(keys)).isDirectory == false {
                    modelData.append(try Data(contentsOf: path))
                    print("Loaded \(type) from \(path.absoluteString)")
                }
            }
            
            let decoder = JSONDecoder()
            let models = try modelData.map({
                try decoder.decode(type, from: $0)
            })
            
            return models
        } catch let e {
            print("\(e)")
        }
        
        return []
    }
}
