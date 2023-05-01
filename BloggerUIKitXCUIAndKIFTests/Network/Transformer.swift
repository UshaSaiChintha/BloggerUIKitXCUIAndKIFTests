//
//  Transformer.swift
//  BloggerUIKitXCUIAndKIFTests
//
//  Created by Usha Sai Chintha on 01/05/23.
//

import Foundation

public protocol Transformable {
    associatedtype Target
    associatedtype Source: Decodable
}

public protocol DomainTransformable: Transformable {
    static func transform(dto: Source) -> Target
}

public protocol DTOTransformable: Transformable {
    static func transform(domain: Target) -> Source
}
