//
//  PageModel.swift
//  Pinch
//
//  Created by Md Faizul karim on 13/7/24.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
