# PHSheet

**PHSheet** is a bottom sheet that display content just like when you connect AirPods.

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

![Banner](/Assets/Docs.png)
         
