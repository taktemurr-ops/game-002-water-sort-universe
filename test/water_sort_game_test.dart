import 'package:flutter_test/flutter_test.dart';
import 'package:game_002_water_sort_universe/game/water_sort_game.dart';

void main() {
  group('WaterSortGame', () {
    test('rejects invalid initial capacity', () {
      expect(() => WaterSortGame([[0, 0, 0, 0, 0]]), throwsArgumentError);
    });

    test('rejects pouring onto a different color', () {
      final game = WaterSortGame([[1], [2], []]);
      expect(game.canPour(0, 1), false);
      expect(game.pour(0, 1), 0);
      expect(game.moves, 0);
    });

    test('pours consecutive same-colored top layers', () {
      final game = WaterSortGame([[0, 1, 1], [], []]);
      expect(game.pour(0, 1), 2);
      expect(game.tubes, [
        [0],
        [1, 1],
        <int>[],
      ]);
      expect(game.moves, 1);
    });

    test('pour respects target capacity', () {
      final game = WaterSortGame([[2, 2, 2], [2, 2, 2], []]);
      expect(game.pour(0, 1), 1);
      expect(game.tubes[0], [2, 2]);
      expect(game.tubes[1], [2, 2, 2, 2]);
    });

    test('undo restores the exact board and move count', () {
      final game = WaterSortGame([[1, 1], [], []]);
      expect(game.pour(0, 1), 2);
      expect(game.undo(), true);
      expect(game.tubes, [
        [1, 1],
        <int>[],
        <int>[],
      ]);
      expect(game.moves, 0);
      expect(game.undo(), false);
    });

    test('solved requires full monochrome or empty tubes', () {
      expect(WaterSortGame([[0, 0, 0, 0], [1, 1, 1, 1], []]).solved, true);
      expect(WaterSortGame([[0, 0], []]).solved, false);
      expect(WaterSortGame.demo().solved, false);
    });
  });
  test('legal move hints do not mutate the board', () {
    final game = WaterSortGame([[1], [], [2]]);
    final before = game.tubes.map((t) => List<int>.from(t)).toList();
    expect(game.legalMoves, contains((0, 1)));
    expect(game.legalMoves, isNot(contains((0, 2))));
    expect(game.tubes, before);
    expect(game.moves, 0);
  });

}
