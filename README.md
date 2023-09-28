# WebAPIClient

A Swift package for fetching web resources, built using modern Swift concurrency. It supports features like retry attempts with duration and fetching nested resources by a given key path. This solution was inspired by Paul Hudson's [Modern, safe networking](https://www.hackingwithswift.com/plus/unwrap-live-2023/modern-safe-networking).

### Defining app environments

```swift
import WebAPIClient

typealias AppEnvironment = WebAPIClient.Environment

extension AppEnvironment {
  #if DEBUG
  static let development = Self(
    name: "Development",
    baseURL: URL(string: "https://theapp.dev")!,
    session: {
      let config = URLSessionConfiguration.ephemeral
      config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
      config.httpAdditionalHeaders = ["ApiKey" : "test-key"]
      return URLSession(configuration: config)
    }()
  )
  #endif
  
  static let production = Self(
    name: "Production",
    baseURL: URL(string: "https://theapp")!,
    session: {
      let config = URLSessionConfiguration.default
      config.httpAdditionalHeaders = ["ApiKey": "production-key"]
      return URLSession(configuration: config)
    }()
  )
}
```
                      
### Defining resources

```swift
typealias Resource = WebAPIClient.Resource
                                                                                                                                      
extension Resource where Value == [User] {
  static let users = Self(
    path: "users",
    type: [User].self
  )
}
extension Resource where Value == [Message] {
  static let messages = Self(
    path: "messages",
    type: [Message].self
  )
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
  // error handling
}
```

### Other features: retry, nested resources

```swift
do {
  let user = try await client.fetch(
    .user,
    attempts: 3,
    delay: .seconds(1)
  )
  // ...
} catch {
  // error handling
}
```
              
```swift
extension Resource where Value == String {
  static let nestedString = Self(
    path: "some/big/response",
    keyPath: "response.user.address.city",
    type: String.self
  )
}
```

```swift
do {
  let city = try await client.fetch(.nestedString)
  // ...
} catch {
  // error handling
}
```
        
### SwiftUI environment
                                                                           
The client can be passed into the environment like this
                                                                                                                                                                                       
```swift
struct WebAPIClientKey: EnvironmentKey {
  static var defaultValue = WebAPIClient(environment: .development)
}

extension EnvironmentValues {
  var apiClient: WebAPIClient {
    get { self[WebAPIClientKey.self] }
    set { self[WebAPIClientKey.self] = newValue }
  }
}
```

```swift
@main
struct NetworkingAppApp: App {
  let client = WebAPIClient(environment: .development)
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.apiClient, client)
    }
  }
}
```
                                                                           
```swift
struct UsersList: View {
  @Environment(\.apiClient) var client
  @State private var users: [User] = []
  
  var body: some View {
    // ...
  }
  .task {
    users = try? await client.fetch(.users)
  }
```

### Multipart data

```swift
var multipart = MultipartData()
multipart.add(key: "model_type", value: "A")
multipart.add(key: "voice_type", value: "Jane")
multipart.add(key: "source_audio_file", fileName: "recording.wav", fileData: audioData, mimeType: "audio/wav")

var request = URLRequest(url: uploadURL)
request.httpBody = multipart.data
request.allHTTPHeaderFields = [
  "Authorization" : "app-token",
  "Content-Type" : multipart.contentType
]
```
