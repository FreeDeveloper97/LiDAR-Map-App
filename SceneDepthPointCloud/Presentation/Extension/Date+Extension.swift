//
//  Date+Extension.swift
//  SceneDepthPointCloud
//
//  Created by Kang Minsang on 2023/07/14.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

extension Date {
    var yyyyMMddHHmm: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        return dateFormatter.string(from: self)
    }
}
