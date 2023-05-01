//
//  BlogPostDTO.swift
//  BloggerUIKitXCUIAndKIFTests
//
//  Created by Usha Sai Chintha on 01/05/23.
//

import Foundation

struct BlogPostDTO: Decodable {
    
    let id: Int
    let title: String
    let body: String
    let userId: Int
}
