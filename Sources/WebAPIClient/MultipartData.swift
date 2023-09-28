//
//  MultipartData.swift
//

import Foundation

public struct MultipartData {
  private static let boundary = UUID().uuidString
  private var _data: Data
  
  public init() {
    self._data = Data()
  }
  
  public var contentType: String {
    "multipart/form-data; boundary=\(MultipartData.boundary)"
  }
  
  public var data: Data {
    var body = _data
    body.append("--\(MultipartData.boundary)--")
    return body
  }
  
  public mutating func add(
    key: String,
    value: String
  ) {
    _data.append("--\(MultipartData.boundary)\r\n")
    _data.append("Content-Disposition: form-data; name=\"\(key)\"" + "\r\n")
    _data.append("\r\n")
    _data.append(value + "\r\n")
  }
  
  public mutating func add(
    key: String,
    fileName: String,
    fileData: Data,
    mimeType: String
  ) {
    _data.append("--\(MultipartData.boundary)\r\n")
    _data.append("Content-Disposition: form-data; name=\"\(key)\"" + "; filename=\"\(fileName)\"" + "\r\n")
    _data.append("Content-Type: \(mimeType)" + "\r\n" + "\r\n")
    _data.append(fileData)
    _data.append("\r\n")
  }
}

private extension Data {
  mutating func append(_ string: String) {
    let stringData = string.data(using: .utf8)!
    self.append(stringData)
  }
}

