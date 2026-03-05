import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pixelplay/app/pixelplay_app.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  testWidgets('shows bottom navigation tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const PixelPlayApp());

    expect(find.text('首页'), findsOneWidget);
    expect(find.text('网络共享'), findsOneWidget);
    expect(find.text('收藏'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
  });

  testWidgets('android back pops album to library', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PixelPlayApp());

    await tester.tap(find.text('相册 1'));
    await tester.pumpAndSettle();

    expect(find.text('本地媒体'), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('本地媒体'), findsOneWidget);
  });
}
