import 'dart:async';

/// Combines two never-completing streams (Drift watches) into one.
///
/// Emits only after both sources have produced a value, and forwards errors.
/// Cancelling the returned stream cancels both subscriptions.
Stream<R> combineLatest2<A, B, R>(
  Stream<A> first,
  Stream<B> second,
  R Function(A a, B b) combine,
) {
  return _CombineLatest2<A, B, R>(first, second, combine).stream;
}

class _CombineLatest2<A, B, R> {
  _CombineLatest2(this.first, this.second, this.combine);

  final Stream<A> first;
  final Stream<B> second;
  final R Function(A, B) combine;

  late final StreamController<R> _controller = StreamController<R>(
    onListen: _onListen,
    onCancel: _onCancel,
  );

  StreamSubscription<A>? _subA;
  StreamSubscription<B>? _subB;
  A? _lastA;
  B? _lastB;
  bool _hasA = false;
  bool _hasB = false;
  bool _doneA = false;
  bool _doneB = false;
  bool _closed = false;

  Stream<R> get stream => _controller.stream;

  void _onListen() {
    _subA = first.listen(
      (A value) {
        _lastA = value;
        _hasA = true;
        _emit();
      },
      onError: _addError,
      onDone: () {
        _doneA = true;
        _maybeClose();
      },
    );
    _subB = second.listen(
      (B value) {
        _lastB = value;
        _hasB = true;
        _emit();
      },
      onError: _addError,
      onDone: () {
        _doneB = true;
        _maybeClose();
      },
    );
  }

  void _emit() {
    if (_closed || !_hasA || !_hasB) return;
    _controller.add(combine(_lastA as A, _lastB as B));
  }

  void _addError(Object error, StackTrace stackTrace) {
    if (_closed) return;
    _controller.addError(error, stackTrace);
  }

  void _maybeClose() {
    if (_doneA && _doneB && !_closed) {
      _closed = true;
      _controller.close();
    }
  }

  Future<void> _onCancel() async {
    _closed = true;
    await _subA?.cancel();
    await _subB?.cancel();
  }
}

/// Combines three never-completing streams.
Stream<R> combineLatest3<A, B, C, R>(
  Stream<A> first,
  Stream<B> second,
  Stream<C> third,
  R Function(A a, B b, C c) combine,
) {
  return combineLatest2(
    combineLatest2(first, second, (A a, B b) => (a, b)),
    third,
    ((A, B) pair, C c) => combine(pair.$1, pair.$2, c),
  );
}
