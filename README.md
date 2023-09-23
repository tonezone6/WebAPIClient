# WebAPIClient

A Swift package for fetching web resources, built using modern Swift concurrency. It supports features like retry attempts with duration and fetching nested resources by a given key path. This solution was inspired by Paul Hudson's [Modern, safe networking](https://www.hackingwithswift.com/plus/unwrap-live-2023/modern-safe-networking).

### Defining app environments

```swift
#if DEBUG
static let development = Self(
  name: "Development",
  baseURL: URL(string: "https://api.dev")!,
  session: {
    let config = URLSessionConfiguration.ephemeral
    config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    config.httpAdditionalHeaders = ["APIKey" : "test-key"]
    return URLSession(configuration: config)
  }()
)
#endif
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
  let apiClient = WebAPIClient(environment: .development)
  let users = try await apiClient.fetch(.users)
  let messages = try await apiClient.fetch(.messages)
  // ...
} catch {
  // Error handling
}
```

### Other features: retry, fetching nested resources

```swift
do {
  let user = try await apiClient.fetch(.user, attempts: 3, delay: .seconds(1))
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

do {
  let city = try await apiClient.fetch(.city)
  // ...
} catch {
  // Error handling
}
```
