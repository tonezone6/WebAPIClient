//
//  WebAPIClient-Resource.swift
//

import Foundation

extension WebAPIClient {
  public struct Resource<Value: Decodable> {
    public var path: String
    public var keyPath: String?
    public var type: Value.Type
    public var method: HTTPMethod
    public var headers: [String : String]
    public var body: Data?
    
    public init(
      path: String,
      keyPath: String? = nil,
      type: Value.Type,
      method: HTTPMethod = .get,
      headers: [String : String] = [:],
      body: Data? = nil
    ) {
      self.path = path
      self.keyPath = keyPath
      self.type = type
      self.method = method
      self.headers = headers
      self.body = body
    }
  }
}
