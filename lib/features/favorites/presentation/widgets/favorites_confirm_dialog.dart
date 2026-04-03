import 'package:flutter/material.dart';

import '../../../../shared/widgets/pp_dialog.dart';

Future<bool> showFavoritesConfirmationDialog(
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
    icon: Icons.folder_delete_outlined,
    tone: PPDialogTone.destructive,
  );
}
