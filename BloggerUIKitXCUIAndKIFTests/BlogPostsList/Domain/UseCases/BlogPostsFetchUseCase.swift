//
//  BlogPostsFetchUseCase.swift
//  BloggerUIKitXCUIAndKIFTests
//
//  Created by Usha Sai Chintha on 01/05/23.
//

import Foundation
import Combine

protocol UseCase {
    associatedtype Repository
    init(respository: Repository)
}

struct BlogPostsFetchUseCase: UseCase {
    
    private let repository: BlogPostsRepository
    
    init(respository: BlogPostsRepository) {
        self.repository = respository
    }
    
    func invoke() -> AnyPublisher<[BlogPost], Error> {
        repository.fetchBlogPosts()
    }
}
