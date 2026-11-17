# Water Sort Universe — release acceptance

This patch is an offline development snapshot, NOT a finished App Store / Google Play release.

## Core gameplay
- [x] Water sort rules: color grouping, four-layer capacity, invalid move handling, undo
- [x] Deterministic campaign templates and reproducible variants (120 indices)
- [x] Bounded breadth-first solver and playable hint paths
- [x] Classic, 180-second timed, UTC daily, zen game variants
- [x] Turkish/English/Arabic strings, RTL direction and semantic tube controls
- [x] Save/resume, level unlocks, best moves, settings and data erasure
- [x] Accessible button labels; responsive tubes, selectable contrast, tactile/audio feedback
- [x] Flutter unit/widget test suites written

## Release gates that must be demonstrated with actual evidence
- [ ] `flutter pub get`, `flutter analyze --fatal-infos` and `flutter test` pass on clean checkout
- [ ] Android emulator and real-device smoke tests, tablet/layout and offline persistence
- [ ] iOS simulator/device test and signed IPA, Apple account/signing profile
- [ ] Android signed release AAB, keystore and Play Console compliance
- [ ] Store listing graphics/screenshots/description, privacy disclosures, support URL
- [ ] Third-party dependency/license reviews and release crash monitoring
- [ ] Age rating/content disclosures and optional ads/IAP real SDK + consent/restore verification

## Monetization
Existing repository monetization policy modules are intentionally retained.
No fake rewarded ad, purchase confirmation, or client-side receipt verification
is presented as a working production SDK. No ads or paid items are enabled in
the application UI until real store identifiers, consent and backend receipt
verification can be configured and tested. Offline app remains fully playable.

## Current GitHub Actions diagnosis
CI run 44051281700 failed in the `flutter analyze` step with 10 info-level
lint findings. The package includes a deterministic lint repair script that
must be applied to the existing repository checkout before acceptance testing.
GitHub Actions or signed build success is **not asserted** by this package.
