# State

``` swift
public enum State 
```

## Inheritance

`Equatable`

## Enumeration Cases

### `success`

A success, storing a `Success` value.

``` swift
case success
```

### `failure`

A failure, storing a `Error` value.

``` swift
case failure(Error)
```

### `loading`

A loading, indicates when loading starts

``` swift
case loading
```

## Operators

### `==`

``` swift
public static func == (lhs: State, rhs: State) -> Bool 
```
