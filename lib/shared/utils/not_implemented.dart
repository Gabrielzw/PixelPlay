import 'package:flutter/material.dart';

import '../widgets/pp_toast.dart';

void showNotImplementedSnackBar(BuildContext context, String message) {
  if (!context.mounted) {
    return;
  }
  PPToast.warning(message);
}
