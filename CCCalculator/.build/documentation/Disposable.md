# Disposable

Represents a disposable resource.

``` swift
public protocol Disposable 
```

## Default Implementations

### `disposed(by:)`

Adds `self` to `bag`

``` swift
public func disposed(by bag: DisposeBag) 
```

#### Parameters

  - bag: `DisposeBag` to add `self` to.

## Requirements

### dispose()

Dispose resource.

``` swift
func dispose()
```
