# Water Sort Universe

**Game Studio 100 | Puzzle | Android / iOS | Flutter**

## First playable prototype committed
- Select source and destination tubes by tapping
- Four-layer tube capacity, same-color contiguous pours
- Invalid move feedback and victory detection
- Undo history and level restart
- Pure Dart rules in `lib/game/water_sort_game.dart`
- Six core rule tests in `test/water_sort_game_test.dart`
- Demo level with two colors and one empty tube

## How to run
```bash
flutter pub get
flutter test
flutter run
```

**Verification:** Source and tests are committed to GitHub but have not been
compiled or run with Flutter SDK in this ChatGPT session.

## Next milestones
1. Animated pouring, haptics and polished bottle artwork.
2. Procedurally generated, **solvable** level packs with difficulty validation.
3. Hint system and level undo limits; save/load.
4. Classic, timed, challenge and zen modes.
5. Localization, accessibility, analytics, store policy review.
6. Ads and optional purchases after consent and correct integration tests.

The project deliberately avoids copying proprietary game assets and branding.
See `docs/` for the roadmap and feature research backlog.
