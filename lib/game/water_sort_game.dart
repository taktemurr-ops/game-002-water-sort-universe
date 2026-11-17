/// Deterministic, UI-independent Water Sort rules. Contents are bottom-to-top.
/// Never share mutable tube lists across snapshots or saved sessions.
class WaterSortGame {
  static const int capacity = 4;
  final List<List<int>> tubes;
  final List<List<List<int>>> _history = <List<List<int>>>[];
  int moves = 0;
  int totalPoured = 0;

  WaterSortGame(List<List<int>> initial)
      : tubes = initial.map((tube) => List<int>.of(tube)).toList() {
    _validate(initial);
  }

  static void _validate(List<List<int>> initial) {
    if (initial.length < 2 ||
        initial.any((tube) => tube.length > capacity ||
            tube.any((color) => color < 0 || color > 99))) {
      throw ArgumentError('Invalid board: at least two tubes, maximum four layers and color IDs 0..99 required.');
    }
  }

  factory WaterSortGame.demo() => WaterSortGame(<List<int>>[
        <int>[0, 1, 0, 1],
        <int>[1, 0, 1, 0],
        <int>[],
      ]);

  bool get solved => tubes.every((tube) => tube.isEmpty ||
      (tube.length == capacity && tube.every((color) => color == tube.first)));
  bool get canUndo => _history.isNotEmpty;
  int get usedColors => tubes.expand((tube) => tube).toSet().length;
  int get totalLayers => tubes.fold(0, (total, tube) => total + tube.length);

  bool canPour(int from, int to) {
    if (from == to || from < 0 || to < 0 ||
        from >= tubes.length || to >= tubes.length) { return false; }
    final source = tubes[from];
    final target = tubes[to];
    if (source.isEmpty || target.length == capacity) { return false; }
    if (target.isNotEmpty && target.last != source.last) { return false; }
    // Moving a complete uniform tube into an empty one never creates progress.
    // It is legal, but hint search will omit these redundant branches.
    return true;
  }

  List<(int, int)> get legalMoves {
    final moves = <(int, int)>[];
    for (var from = 0; from < tubes.length; from++) {
      for (var to = 0; to < tubes.length; to++) {
        if (canPour(from, to)) { moves.add((from, to)); }
      }
    }
    return moves;
  }

  int pour(int from, int to) {
    if (!canPour(from, to)) { return 0; }
    final source = tubes[from];
    final target = tubes[to];
    final color = source.last;
    var contiguous = 0;
    for (var i = source.length - 1; i >= 0 && source[i] == color; i--) {
      contiguous++;
    }
    final available = capacity - target.length;
    final moved = contiguous < available ? contiguous : available;
    if (moved == 0) { return 0; }
    _history.add(snapshot());
    // Cap history to avoid unbounded memory use in extended Zen sessions.
    if (_history.length > 500) { _history.removeAt(0); }
    for (var i = 0; i < moved; i++) {
      target.add(source.removeLast());
    }
    moves++;
    totalPoured += moved;
    return moved;
  }

  List<List<int>> snapshot() => tubes.map((tube) => List<int>.of(tube)).toList();

  bool undo() {
    if (_history.isEmpty) { return false; }
    final previous = _history.removeLast();
    _replaceBoard(previous);
    moves--;
    return true;
  }

  void reset(List<List<int>> initial) {
    _validate(initial);
    if (initial.length != tubes.length) { throw ArgumentError('Tube count changed'); }
    _replaceBoard(initial);
    _history.clear();
    moves = 0;
    totalPoured = 0;
  }

  void _replaceBoard(List<List<int>> replacement) {
    for (var i = 0; i < tubes.length; i++) {
      tubes[i]..clear()..addAll(replacement[i]);
    }
  }
}
