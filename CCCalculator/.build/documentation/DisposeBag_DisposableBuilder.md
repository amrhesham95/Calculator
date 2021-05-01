# DisposeBag.DisposableBuilder

A function builder accepting a list of Disposables and returning them as an array.

``` swift
@_functionBuilder
  public struct DisposableBuilder 
```

## Methods

### `buildBlock(_:)`

``` swift
public static func buildBlock(_ disposables: Disposable...) -> [Disposable] 
```
