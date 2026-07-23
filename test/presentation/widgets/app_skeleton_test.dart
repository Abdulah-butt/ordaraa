import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/core/theme/light_theme.dart';
import 'package:ordaraa/presentation/widgets/app_skeleton.dart';

void main() {
  testWidgets('AppSkeletonBox fills available width when width is omitted', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildOrdaraLightTheme(),
        home: const Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [AppSkeletonBox(height: 120)]),
          ),
        ),
      ),
    );

    final size = tester.getSize(find.byType(AppSkeletonBox));

    expect(size.width, greaterThan(0));
    expect(size.height, 120);
  });
}
