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
            self.save(data: data, folder: "\(type(of: model))", filename: "\(key).json")
        } catch let e {
            print("\(e)")
        }
    }
    
    static func save(data: Data, folder: String, filename: String) {
        do {
            let dirURL = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let folderURL = dirURL.appendingPathComponent(folder)
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            let writeURL = folderURL.appendingPathComponent(filename)
            try data.write(to: writeURL)
            print("Saved to \(writeURL.absoluteString)")
        } catch let e {
            print("\(e)")
        }
    }
    
    static func loadAll<T: Decodable>(type: T.Type) -> [T] {
        do {
            let decoder = JSONDecoder()
            let models = try self.loadAll(folder: "\(type)").map({
                try decoder.decode(type, from: $0)
            })
            
            return models
        } catch let e {
            print("\(e)")
        }
        
        return []
    }
    
    static func loadAll(folder: String) -> [Data] {
        do {
            let dirURL = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let folderURL = dirURL.appendingPathComponent(folder)
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            
            let keys: [URLResourceKey] = [.isDirectoryKey]
            let paths = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: keys, options: [])
            
            var allData: [Data] = []
            for path in paths {
                if try path.resourceValues(forKeys: Set(keys)).isDirectory == false {
                    allData.append(try Data(contentsOf: path))
                    print("Loaded \(path.absoluteString)")
                }
            }
            
            return allData
        } catch let e {
            print("\(e)")
        }
        
        return []
    }
}
