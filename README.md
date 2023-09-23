# WebAPIClient

A Swift package for fetching web resources, built using modern Swift concurrency. It supports features like retry attempts with duration and fetching nested resources by a given key path. This solution was inspired by Paul Hudson's [Modern, safe networking](https://www.hackingwithswift.com/plus/unwrap-live-2023/modern-safe-networking).

### Defining app environments

```swift
typealias AppEnvironment = WebAPIClient.Environment
extension AppEnvironment {
  #if DEBUG
  static let development = Self(
    name: "Development",
    baseURL: URL(string: "https://api.dev")!,
    session: {
      let config = URLSessionConfiguration.ephemeral
      config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
      config.httpAdditionalHeaders = ["ApiKey" : "some-test-key"]
      return URLSession(configuration: config)
    }()
  )
  #endif
  
  static let production = Self(
    // ...
  )
}
```
                      
### Defining resources
                      
```swift
typealias Resource = WebAPIClient.Resource
extension Resource where Value == [Users] {
  static let users = Self(path: "users", type: [News].self)
}
extension Resource where Value == [Message] {
  static let messages = Self(path: "messages", type: [Message].self)
}
```

### Fetching resources

```swift
do {
  let client = WebAPIClient(environment: .development)
  let users = try await client.fetch(.users)
  let messages = try await client.fetch(.messages)
  // ...
} catch {
  // Error handling
}
```

### Other features: retry, fetching nested resources

```swift
do {
  let user = try await client.fetch(.user, attempts: 3, delay: .seconds(1))
  // ...
} catch {
  // Error handling
}
```
              
```swift
extension Resource where Value == String {
  static let city = Self(
    path: "some/big/response",
    keyPath: "response.user.address.city",
    type: String.self
  )
}

// ...

do {
  let cityString = try await apiClient.fetch(.city)
  // ...
} catch {
  // Error handling
}
```
