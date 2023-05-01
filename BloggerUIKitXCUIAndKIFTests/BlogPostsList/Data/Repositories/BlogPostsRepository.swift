//
//  BlogPostsRepository.swift
//  BloggerUIKitXCUIAndKIFTests
//
//  Created by Usha Sai Chintha on 01/05/23.
//

import UIKit
import Combine

protocol BlogPostsRepository {
    func fetchBlogPosts() -> AnyPublisher<[BlogPost], Error>
}


open class APIService {
    
    public let apiClient: APIClient
    
    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}

class BlogPostsRepositoryImpl: APIService, BlogPostsRepository {
    
    func fetchBlogPosts() -> AnyPublisher<[BlogPost], Error> {
        let request = BlogPostListRequest()
        return self.apiClient.fetch(request: request, transformableType: BlogPostDataTransformer.self)
    }
}
