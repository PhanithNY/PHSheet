# PHSheet

**PHSheet** is a bottom sheet that display content just like when you connect AirPods.
See example project for more details.
![Banner](/Assets/Docs.png)

# Usage
In order to use the sheet, make your `UIViewController` conform to `PHContentInsetPresentable` and call `presentPHSheet`.
``` swift
let sheetViewController: AirPodSheet = .init()
presentPHSheet(sheetViewController, animated: true)
```

In order to use the sheet with `UINavigationController`, subclass or conform to `PHContentInsetPresentable` .
``` swift
let sheetViewController: TableViewController = .init()
let navigationController = UINavigationController(rootViewController: sheetViewController)
presentPHSheet(navigationController, animated: true)
```

### Swift Package Manager
From Xcode menu bar:
1. File
2. Swift Packages
3. Add Package Dependency...
4. Paste the repo url `https://github.com/PhanithNY/PHSheet.git`


## Author

PhanithNY, ny.phanith.fe@gmail.com

## License

PHSheet is available under the MIT license. See the LICENSE file for more info.
