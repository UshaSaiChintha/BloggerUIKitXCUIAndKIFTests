//
//  BlogPostListRequest.swift
//  BloggerUIKitXCUIAndKIFTests
//
//  Created by Usha Sai Chintha on 01/05/23.
//

import Foundation

struct BlogPostListRequest: Request {
    var queryParams: [String : String]? = nil
    var httpMethod: HTTPMethod = .get
    var body: Encodable?
    var endPoint: String = "/posts"
}
