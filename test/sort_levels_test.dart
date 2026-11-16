import 'package:flutter_test/flutter_test.dart';
import 'package:game_002_water_sort_universe/game/sort_levels.dart';
import 'package:game_002_water_sort_universe/game/water_sort_game.dart';

/// Checks each curated level has a valid path to a solved board.
/// Breadth-first search is kept in tests rather than a runtime hint engine.
bool canSolve(List<List<int>> initial) {
  final queue = <List<List<int>>>[initial];
  final visited = <String>{};
  String key(List<List<int>> board) =>
      board.map((t) => t.join(',')).join('|');
  visited.add(key(initial));
  for (var head = 0; head < queue.length; head++) {
    final current = queue[head];
    final game = WaterSortGame(current);
    if (game.solved) return true;
    for (var from = 0; from < current.length; from++) {
      for (var to = 0; to < current.length; to++) {
        final next = WaterSortGame(current);
        final succeeded = next.pour(from, to) > 0;
        if (!succeeded) continue;
        final board = next.tubes.map((t) => List<int>.from(t)).toList();
        if (visited.add(key(board))) queue.add(board);
      }
    }
    if (queue.length > 100000) return false;
  }
  return false;
}

void main() {
  test('all supplied campaign levels are solvable', () {
    expect(SortLevels.count, greaterThanOrEqualTo(4));
    for (var i = 0; i < SortLevels.count; i++) {
      final board = SortLevels.get(i);
      expect(canSolve(board), true, reason: 'Level ${i + 1} must be solvable');
    }
  });

  test('level accessor returns independent mutable copies', () {
    final a = SortLevels.get(0);
    a[0].clear();
    expect(SortLevels.get(0)[0], isNotEmpty);
  });
}
