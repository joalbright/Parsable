# Parsable

Swiftly Parse & Initialize for Archiving & working with JSON

## Usage

```swift
struct Person: Parsable {
    
    var name: String?
    var age: Int = 0
    
    init() { }
    
    init(_ info: ParsedInfo) {
        
        name <-- info["name"]
        age <-- info["age"]
        
    }

}
```

**Class from Example project**

```swift
class Album: Parsable {
    
    var title: String?
    var artist: String?
    var albumImageURL: String?
    var albumImage: UIImage?
    var trackCount: Int?
    var collectionPrice: Double?
    
    required init() { }
    
    required init(_ info: ParsedInfo) {
        
        title <-- info["collectionName"]
        artist <-- info["artistName"]
        albumImageURL <-- info["artworkUrl100"]
        trackCount <-- info["trackCount"]
        collectionPrice <-- info["collectionPrice"]
        
    }
    
}
```

## Author

[Jo Albright](https://github.com/joalbright)

## License

Parsable is available under the MIT license. See the LICENSE file for more info.
