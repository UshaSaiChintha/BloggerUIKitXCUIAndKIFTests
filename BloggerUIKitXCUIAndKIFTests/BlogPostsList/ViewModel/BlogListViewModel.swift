//
//  BlogListViewModel.swift
//  BloggerUIKitXCUIAndKIFTests
//
//  Created by Usha Sai Chintha on 01/05/23.
//

import Foundation
import UIKit
import Combine
import CombineSchedulers
import Factory

class BlogListViewModel {
    
    @Published private(set) var state: ViewModelState<[BlogPost]> = .idle
    @LazyInjected(\.mainScheduler) private var mainScheduler: AnySchedulerOf<DispatchQueue>
    @LazyInjected(\.blogPostRepository) private var repository: BlogPostsRepository
    
    private var useCase: BlogPostsFetchUseCase {
        return BlogPostsFetchUseCase(respository: repository)
    }

    private var cancellable: AnyCancellable?

    func fetchBlogPosts() {
        self.state = .loading
        cancellable = useCase.invoke()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self.state = .error(message: error.localizedDescription)
                default:
                    break
                }
            }, receiveValue: { blogPosts in
                self.state = .success(data: blogPosts)
            })
    }
}
