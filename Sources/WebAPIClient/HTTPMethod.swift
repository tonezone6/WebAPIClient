//
//  WebAPIClient-HTTPMethod.swift
//

extension WebAPIClient {
  public enum HTTPMethod: String {
    case delete, get, patch, post, put
    
    public var rawValue: String {
      String(describing: self).uppercased()
    }
  }
}
