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

    expect(find.text('首页'), findsOneWidget);
    expect(find.text('云盘'), findsOneWidget);
    expect(find.text('收藏'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
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

    expect(find.text('本地媒体'), findsNothing);
    expect(find.text('Screenshots'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('本地媒体'), findsOneWidget);
  });
}
