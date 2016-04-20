# BlurActionSheet
Action sheet with blur effect written in Swift

<div>
<img src="https://raw.githubusercontent.com/iAugux/ProjectScreenshots/master/BlurActionSheet/1.gif" width="272" height=480"/>
</div>

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