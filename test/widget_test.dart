import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_002_water_sort_universe/main.dart';

void main() {
  testWidgets('Water Sort Universe initial screen renders on a phone', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const WaterSortUniverse());
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('Water Sort Universe'), findsOneWidget);
  });
}
