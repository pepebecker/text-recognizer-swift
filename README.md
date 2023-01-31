# TextRecognizer Swift
A swift package that allows you to recognize text in images.

## Features
- Recognize text in CGImage or NSImage
- Support multiple languages
- Recognition can be performed asynchronously with completion handler or synchronously with throws

## Installation
TextRecognizer is available through [Swift Package Manager](https://swift.org/package-manager/). To install it, simply add the following line to your `Package.swift` file's dependencies:

```swift
.package(url: "https://github.com/pepebecker/text-recognizer-swift", from: "0.1.0")
```
Also add the following `product` your your target's dependencies:

```swift
.product(name: "TextRecognizer", package: "text-recognizer-swift"),
```
And then run swift package update to fetch the dependencies.

You can also add TextRecognizer to your Xcode project by going to File > Swift Packages > Add Package Dependency... and entering the repository URL.

## Usage
Import the package
```swift
import TextRecognizer
```

### Supported Languages
You can retrieve a list of supported languages with supportedLanguages:

```swift
do {
  let languages = try TextRecognizer.supportedLanguages()
  print(languages)
} catch {
  print(error)
}
```

### Asynchronous Recognition
You can recognize text in an image asynchronously by providing a completion handler:

```swift
let image = NSImage(named: "sample")!
TextRecognizer.recognize(image: image, languages: ["en-US"]) { result, error in
  if let error = error {
    print(error)
  } else if let result = result {
    print(result)
  }
}
```

### Synchronous Recognition
You can also recognize text in an image synchronously with throws:

```swift
let image = NSImage(named: "sample")!
do {
  let result = try TextRecognizer.recognize(image: image, languages: ["en-US"])
  print(result)
} catch {
  print(error)
}
```

## Requirements
- Xcode 12+
- Swift 5.3+

## Dependencies
- [Vision](https://developer.apple.com/documentation/vision) framework from Apple.

## License
TextRecognizer is released under the ISC license. [See LICENSE](LICENSE) for details.

## Contributing

If you **have a question**, **found a bug** or want to **propose a feature**, have a look at [the issues page](https://github.com/pepebecker/text-recognizer-swift/issues).
