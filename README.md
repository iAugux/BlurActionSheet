# BlurActionSheet
Action sheet with blur effect written in Swift

![image](https://github.com/nathanwhy/BlurActionSheet/raw/master/example.gif)


###Requirements

- Xcode 6.2
- iOS 8.0+

###Usage

```objc

let titles = ["commit","reload image","save image","copy image","share image","cancel"]
        
BlurActionSheet.showWithTitles(titles, handler: { (index) -> Void in
            
     println("selected at \(index)")
})
        
```