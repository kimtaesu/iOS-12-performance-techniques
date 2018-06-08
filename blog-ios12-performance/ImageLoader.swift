//
//  ImageLoader.swift
//  blog-ios12-performance
//
//  Created by ttillage on 6/8/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import UIKit

struct ImageLoader {
    
    private static let session = URLSession(configuration: .default)
    
    static func load(url: URL, completion: @escaping (URL, UIImage?) -> ()) {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10.0)
        self.session.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(url, image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(url, nil)
                }
            }
        }).resume()
    }
}
