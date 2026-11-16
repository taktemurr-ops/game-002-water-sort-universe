/// Water Sort Universe - deterministic rule engine with undo support.
///
/// Tube contents are bottom-to-top. A pour transfers a contiguous run of
/// identical top colors, limited by the destination's free capacity.
class WaterSortGame {
  static const int capacity = 4;

  final List<List<int>> tubes;
  final List<List<List<int>>> _history = [];
  int moves = 0;

  WaterSortGame(List<List<int>> initial)
      : tubes = initial.map((tube) => List<int>.from(tube)).toList() {
    if (tubes.any((tube) => tube.length > capacity || tube.any((c) => c < 0))) {
      throw ArgumentError('Each tube must contain 0–4 nonnegative color IDs.');
    }
  }

  factory WaterSortGame.demo() => WaterSortGame([
        [0, 1, 0, 1],
        [1, 0, 1, 0],
        [],
      ]);

  bool get solved => tubes.every(
        (tube) =>
            tube.isEmpty ||
            (tube.length == capacity && tube.every((c) => c == tube.first)),
      );

  bool get canUndo => _history.isNotEmpty;

  bool canPour(int from, int to) {
    if (from == to || from < 0 || to < 0 || from >= tubes.length || to >= tubes.length) {
      return false;
    }
    final source = tubes[from];
    final target = tubes[to];
    if (source.isEmpty || target.length >= capacity) return false;
    if (target.isNotEmpty && target.last != source.last) return false;
    return true;
  }

  /// Returns how many layers moved (0 means no valid move).
  int pour(int from, int to) {
    if (!canPour(from, to)) return 0;
    final source = tubes[from];
    final target = tubes[to];
    final top = source.last;

    var run = 0;
    for (var i = source.length - 1; i >= 0 && source[i] == top; i--) {
      run++;
    }
    final count = run < capacity - target.length ? run : capacity - target.length;
    _history.add(tubes.map((tube) => List<int>.from(tube)).toList());
    for (var i = 0; i < count; i++) {
      target.add(source.removeLast());
    }
    moves++;
    return count;
  }

  bool undo() {
    if (_history.isEmpty) return false;
    final previous = _history.removeLast();
    for (var i = 0; i < tubes.length; i++) {
      tubes[i]
        ..clear()
        ..addAll(previous[i]);
    }
    moves--;
    return true;
  }

  void reset(List<List<int>> initial) {
    if (initial.length != tubes.length ||
        initial.any((tube) => tube.length > capacity || tube.any((c) => c < 0))) {
      throw ArgumentError('Invalid reset board');
    }
    for (var i = 0; i < tubes.length; i++) {
      tubes[i]
        ..clear()
        ..addAll(initial[i]);
    }
    _history.clear();
    moves = 0;
  }
}
