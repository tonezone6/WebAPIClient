//
//  WebAPIClient.swift
//

import Foundation

public struct WebAPIClient {
  public let environment: Environment
  public let decoder: JSONDecoder
  
  public init(
    environment: Environment,
    decoder: JSONDecoder = .init()
  ) {
    self.environment = environment
    self.decoder = decoder
  }
  
  public func fetch<T>(_ resource: Resource<T>) async throws -> T {
    guard let url = URL(string: resource.path, relativeTo: environment.baseURL) else {
      throw URLError(.unsupportedURL)
    }
    var request = URLRequest(url: url)
    request.httpMethod = resource.method.rawValue
    request.httpBody = resource.body
    request.allHTTPHeaderFields = resource.headers
    
    var (data, _) = try await environment.session.data(for: request)
    
    if let keyPath = resource.keyPath,
       let rootObject = try JSONSerialization.jsonObject(with: data) as? NSDictionary,
       let nestedObject = rootObject.value(forKeyPath: keyPath) {
      data = try JSONSerialization.data(
        withJSONObject: nestedObject, options: .fragmentsAllowed)
    }
    return try decoder.decode(T.self, from: data)
  }
  
  public func fetch<T>(_ resource: Resource<T>, attempts: Int, delay: Duration = .seconds(1)) async throws -> T {
    do {
      return try await fetch(resource)
    } catch {
      if attempts > 1 {
        try await Task.sleep(for: delay)
        return try await fetch(resource, attempts: attempts - 1, delay: delay)
      } else {
        throw error
      }
    }
  }
}
