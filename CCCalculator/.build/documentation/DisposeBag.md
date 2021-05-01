# DisposeBag

Thread safe bag that disposes added disposables on `deinit`.
This returns ARC (RAII) like resource management to `RxSwift`.
In case contained disposables need to be disposed, just put a different dispose bag
or create a new one in its place.
self.existingDisposeBag = DisposeBag()
In case explicit disposal is necessary, there is also `CompositeDisposable`.

``` swift
public final class DisposeBag: DisposeBase 
```

## Inheritance

[`DisposeBase`](/DisposeBase)

## Initializers

### `init()`

Constructs new empty dispose bag.

``` swift
public override init() 
```

### `init(disposing:)`

Convenience init allows a list of disposables to be gathered for disposal.

``` swift
public convenience init(disposing disposables: Disposable...) 
```

### `init(builder:)`

Convenience init which utilizes a function builder to let you pass in a list of
disposables to make a DisposeBag of.

``` swift
public convenience init(@DisposableBuilder builder: () -> [Disposable]) 
```

### `init(disposing:)`

Convenience init allows an array of disposables to be gathered for disposal.

``` swift
public convenience init(disposing disposables: [Disposable]) 
```

## Methods

### `insert(_:)`

Adds `disposable` to be disposed when dispose bag is being deinited.

``` swift
public func insert(_ disposable: Disposable) 
```

#### Parameters

  - disposable: Disposable to add.

### `insert(_:)`

Convenience function allows a list of disposables to be gathered for disposal.

``` swift
public func insert(_ disposables: Disposable...) 
```

### `insert(builder:)`

Convenience function allows a list of disposables to be gathered for disposal.

``` swift
public func insert(@DisposableBuilder builder: () -> [Disposable]) 
```

### `insert(_:)`

Convenience function allows an array of disposables to be gathered for disposal.

``` swift
public func insert(_ disposables: [Disposable]) 
```
