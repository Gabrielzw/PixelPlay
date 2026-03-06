import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:pixelplay/app/pixelplay_app.dart';
import 'package:pixelplay/features/media_library/presentation/widgets/library_album_card.dart';
import 'package:pixelplay/features/settings/data/in_memory_settings_repository.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  testWidgets('shows bottom navigation items', (WidgetTester tester) async {
    await tester.pumpWidget(
      PixelPlayApp(settingsRepository: InMemorySettingsRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.byIcon(Icons.cloud_outlined), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    expect(find.text('首页'), findsOneWidget);
  });

  testWidgets('android back pops album to library', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      PixelPlayApp(settingsRepository: InMemorySettingsRepository()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(LibraryAlbumCard).first);
    await tester.pumpAndSettle();

    expect(find.text('Pixel Play'), findsNothing);
    expect(find.text('Screenshots'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Pixel Play'), findsOneWidget);
  });
}
