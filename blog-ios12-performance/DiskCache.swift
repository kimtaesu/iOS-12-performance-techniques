//
//  DiskCache.swift
//  blog-ios12-performance
//
//  Created by ttillage on 6/8/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import Foundation

struct DiskCache {
    
    private static let ioQueue = DispatchQueue(label: "com.disk-cache.io", qos: .utility)
    
    static func performAsync(_ block: @escaping () -> ()) {
        self.ioQueue.async(execute: block)
    }
    
    static func save<T: Encodable>(model: T, key: String) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(model)
            self.save(data: data, folder: "\(type(of: model))", filename: "\(key).json")
        } catch let e {
            print("Serialize Model Error: \(e)")
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
            print("Disk Save Error: \(e)")
        }
    }
    
    static func load<T: Decodable>(type: T.Type, key: String) -> T? {
        do {
            if let data = self.load(folder: "\(type)", filename: "\(key).json") {
                let decoder = JSONDecoder()
                return try decoder.decode(type, from: data)
            }
        } catch let e {
            print("Deserialize Model Error: \(e)")
        }
        
        return nil
    }
    
    static func load(folder: String, filename: String, ignoreErrors: Bool = false) -> Data? {
        do {
            let dirURL = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let folderURL = dirURL.appendingPathComponent(folder)
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            let readURL = folderURL.appendingPathComponent(filename)
            return try Data(contentsOf: readURL)
        } catch let e {
            if !ignoreErrors {
                print("Disk Load Error: \(e)")
            }
        }
        
        return nil
    }
    
    static func loadAll<T: Decodable>(type: T.Type) -> [T] {
        do {
            let decoder = JSONDecoder()
            let models = try self.loadAll(folder: "\(type)").map({ data, filename in
                try decoder.decode(type, from: data)
            })
            
            return models
        } catch let e {
            print("Deserialize Model Error: \(e)")
        }
        
        return []
    }
    
    static func loadAll(folder: String) -> [(data: Data, filename: String)] {
        do {
            let dirURL = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let folderURL = dirURL.appendingPathComponent(folder)
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            
            let keys: [URLResourceKey] = [.isDirectoryKey]
            let paths = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: keys, options: [])
            
            var allData: [(data: Data, filename: String)] = []
            for path in paths {
                if try path.resourceValues(forKeys: Set(keys)).isDirectory == false {
                    let data = try Data(contentsOf: path)
                    let filename = path.lastPathComponent
                    allData.append((data: data, filename: filename))
                    print("Loaded \(path.absoluteString)")
                }
            }
            
            return allData
        } catch let e {
            print("Disk Load Error \(e)")
        }
        
        return []
    }
}
