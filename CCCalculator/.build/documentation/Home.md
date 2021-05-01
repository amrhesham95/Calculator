# Types

  - [DisposeBag](/DisposeBag):
    Thread safe bag that disposes added disposables on `deinit`.
    This returns ARC (RAII) like resource management to `RxSwift`.
    In case contained disposables need to be disposed, just put a different dispose bag
    or create a new one in its place.
    self.existingDisposeBag = DisposeBag()
    In case explicit disposal is necessary, there is also `CompositeDisposable`.
  - [DisposeBase](/DisposeBase):
    Base class for all disposables.
  - [State](/State)
  - [DisposeBag.DisposableBuilder](/DisposeBag_DisposableBuilder):
    A function builder accepting a list of Disposables and returning them as an array.

# Protocols

  - [Disposable](/Disposable):
    Represents a disposable resource.

# Extensions

  - [NSNotification.Name](/NSNotification_Name)
