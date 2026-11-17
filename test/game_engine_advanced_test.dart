import 'package:flutter_test/flutter_test.dart';
import 'package:game_002_water_sort_universe/game/game_mode.dart';
import 'package:game_002_water_sort_universe/game/sort_levels.dart';
import 'package:game_002_water_sort_universe/game/water_sort_game.dart';
import 'package:game_002_water_sort_universe/game/water_sort_solver.dart';

void main() {
  test('all campaign levels have a verified winning path', () {
    expect(SortLevels.count, 120);
    for (var i = 0; i < SortLevels.count; i++) {
      final level = SortLevels.get(i);
      final solution = WaterSortSolver.solve(level);
      expect(solution, isNotNull, reason: 'Level $i must be solvable');
      final game = WaterSortGame(level);
      for (final move in solution!) {
        expect(game.pour(move.$1, move.$2), greaterThan(0));
      }
      expect(game.solved, isTrue, reason: 'Level $i path must win');
    }
  });

  test('solver is deterministic and does not mutate source board', () {
    final board = SortLevels.get(2);
    final before = board.map((tube) => List<int>.of(tube)).toList();
    final a = WaterSortSolver.solve(board);
    final b = WaterSortSolver.solve(board);
    expect(a, b);
    expect(board, before);
  });

  test('undo does not modify a non-existent history', () {
    final game = WaterSortGame(SortLevels.get(0));
    expect(game.undo(), isFalse);
    expect(game.moves, 0);
  });

  test('invalid pours never mutate game board or move counter', () {
    final game = WaterSortGame(SortLevels.get(0));
    final copy = game.snapshot();
    expect(game.pour(-1, 0), 0);
    expect(game.pour(0, 100), 0);
    expect(game.pour(0, 0), 0);
    expect(game.moves, 0);
    expect(game.snapshot(), copy);
  });

  test('reset restores the exact initial board', () {
    final initial = SortLevels.get(0);
    final game = WaterSortGame(initial);
    game.pour(0, 2);
    game.reset(initial);
    expect(game.tubes, initial);
    expect(game.canUndo, isFalse);
    expect(game.moves, 0);
  });

  test('multiple restores do not share mutable tube lists', () {
    final a = SortLevels.get(2);
    final b = SortLevels.get(2);
    a[0][0] = 99;
    expect(a, isNot(equals(b)));
  });

  test('timed and daily modes have distinct rules', () {
    expect(GameMode.timed.limitSeconds, 180);
    expect(GameMode.classic.limitSeconds, isNull);
    expect(GameMode.daily.allowsHints, isFalse);
    expect(GameMode.zen.allowsHints, isTrue);
  });

  test('invalid boards are rejected', () {
    expect(() => WaterSortGame(<List<int>>[<int>[]]), throwsArgumentError);
    expect(() => WaterSortGame(<List<int>>[<int>[100], <int>[]]), throwsArgumentError);
    expect(() => WaterSortGame(<List<int>>[<int>[-1], <int>[]]), throwsArgumentError);
  });
}
