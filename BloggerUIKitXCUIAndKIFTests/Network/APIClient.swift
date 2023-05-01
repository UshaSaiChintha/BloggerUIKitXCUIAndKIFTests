//
//  APIClient.swift
//  BloggerUIKitXCUIAndKIFTests
//
//  Created by Usha Sai Chintha on 01/05/23.
//

import Combine
import Foundation

public protocol APIClient {
    init(url: URL, urlSession: URLSession)
    func fetch<T>(request: Request, transformableType: T.Type) -> AnyPublisher<T.Target, Error> where T: DomainTransformable
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Environment {
    var baseURL: URL { get }
}

public protocol Request {
    var queryParams: [String: String]? { get set }
    var httpMethod: HTTPMethod { get set }
    var body: Encodable? { get set }
    var endPoint: String { get set }
}

extension Equatable where Self: Request {}

struct RequestBuilder {
    
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func build(request: Request) throws -> URLRequest {
        let url = buildURL(request: request)
        var urlRequest = URLRequest(url: url)
        if let body = request.body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }
        urlRequest.httpMethod = request.httpMethod.rawValue
        return urlRequest
    }
    
    private func buildURL(request: Request) -> URL {
        var urlComponent = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        var endPoint = request.endPoint
        if !request.endPoint.starts(with: "/") {
            endPoint = "/\(endPoint)"
        }
        urlComponent.path = endPoint
        urlComponent.queryItems = request.queryParams?.map(URLQueryItem.init)
        return urlComponent.url!
    }
}

open class RESTAPIClient: APIClient {
    
    private let urlSession: URLSession
    private let requestBuilder: RequestBuilder
    
    public required init(url: URL, urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        self.requestBuilder = RequestBuilder(baseURL: url)
    }
    
    public func fetch<T>(request: Request, transformableType: T.Type = T.self) -> AnyPublisher<T.Target, Error> where T: DomainTransformable {
        urlSession.dataTaskPublisher(for: try! requestBuilder.build(request: request))
            .tryMap() { element -> Data in
            guard let httpResponse = element.response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            return element.data
            }
        .decode(type: T.Source.self, decoder: JSONDecoder())
        .map { transformableType.transform(dto: $0 )}
        .eraseToAnyPublisher()
    }
}

open class SOAPAPIClient: APIClient {
    
    private let urlSession: URLSession
    private let requestBuilder: RequestBuilder
    
    public required init(url: URL, urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        self.requestBuilder = RequestBuilder(baseURL: url)
    }
    
    public func fetch<T>(request: Request, transformableType: T.Type = T.self) -> AnyPublisher<T.Target, Error> where T: DomainTransformable {
        urlSession.dataTaskPublisher(for: try! requestBuilder.build(request: request))
            .tryMap() { element -> Data in
            guard let httpResponse = element.response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            return element.data
            }
        .decode(type: T.Source.self, decoder: JSONDecoder())
        .map { transformableType.transform(dto: $0 )}
        .eraseToAnyPublisher()
    }
}


