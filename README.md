# Game 002 — Water Sort Universe | offline feature package

This is a complete *source-code overlay* for the **existing** private
`taktemurr-ops/game-002-water-sort-universe` Flutter repository, not a new game
repository. It includes improved game engine, bounded solver, 120 reproducible
campaign boards, localized responsive UI, local progression and settings,
unit/widget tests and a CI workflow. The original repo's monetization policy
modules and tests must be retained.

## Apply to an existing checkout

```bash
python3 tools/apply_to_repo.py /path/to/game-002-water-sort-universe
cd /path/to/game-002-water-sort-universe
flutter pub get
flutter analyze --fatal-infos
flutter test
flutter build apk --debug
```

Source snapshot uploaded to GitHub at the user's request. CI and mobile/store release gates have NOT yet been confirmed successful.
Existing repository code is preserved by copying only overlapping paths.

## What this package does NOT claim

It does not claim an Android or iOS build has passed, or that SDK-based ads,
verified purchases, store signed releases, privacy store forms or live store
submissions have been completed. See `docs/RELEASE_READINESS.md` for hard gates.

GitHub game-002 issue: https://github.com/taktemurr-ops/game-002-water-sort-universe/issues/1
