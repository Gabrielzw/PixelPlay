import 'package:flutter/material.dart';

import '../../../../shared/widgets/pp_dialog.dart';

Future<bool> showWatchHistoryConfirmationDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String confirmLabel,
}) async {
  return showPPConfirmDialog(
    context,
    title: title,
    message: content,
    confirmLabel: confirmLabel,
    icon: Icons.history_toggle_off_rounded,
    tone: PPDialogTone.destructive,
  );
}
