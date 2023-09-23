//
//  WebAPIClient-Environment.swift
//

import Foundation

extension WebAPIClient {
  public struct Environment {
    public var name: String
    public var baseURL: URL
    public var session: URLSession
    
    public init(name: String, baseURL: URL, session: URLSession) {
      self.name = name
      self.baseURL = baseURL
      self.session = session
    }
  }
}
