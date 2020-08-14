//
//  UIImage+save.swift
//  boost_project
//
//  Created by 현기엽 on 2020/08/14.
//  Copyright © 2020 남기범. All rights reserved.
//

import UIKit

extension UIImage {
    /// Save PNG in the Documents directory
    func save(_ name: String) {
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let url = URL(fileURLWithPath: path).appendingPathComponent(name)
        try! self.pngData()?.write(to: url)
        print("saved image at \(url)")
    }
    
    static func load(_ name: String) -> UIImage {
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let url = URL(fileURLWithPath: path).appendingPathComponent(name)
        let ret = try! UIImage(data: Data(contentsOf: url))!
        print("saved image at \(url)")
        return ret
    }
}
