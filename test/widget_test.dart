import 'package:flutter_test/flutter_test.dart';

import 'package:pixelplay/app/pixelplay_app.dart';
import 'package:pixelplay/app/settings/app_settings_controller.dart';
import 'package:pixelplay/app/settings/app_settings_scope.dart';
import 'package:pixelplay/app/settings/app_settings_state.dart';

void main() {
  testWidgets('shows bottom navigation tabs', (WidgetTester tester) async {
    final controller = AppSettingsController(const AppSettingsState());

    await tester.pumpWidget(
      AppSettingsScope(controller: controller, child: const PixelPlayApp()),
    );

    expect(find.text('首页'), findsOneWidget);
    expect(find.text('网络共享'), findsOneWidget);
    expect(find.text('收藏'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
  });
}
