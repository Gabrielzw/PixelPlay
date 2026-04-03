import 'package:flutter/material.dart';

const double _kPPDialogHorizontalInset = 24;
const double _kPPDialogMaxWidth = 420;
const double _kPPDialogRadius = 32;
const double _kPPDialogActionHeight = 54;
const double _kPPDialogHeaderSize = 56;
const double _kPPDialogBorderOpacity = 0.5;
const double _kPPDialogShadowOpacity = 0.16;
const double _kPPDialogBarrierOpacity = 0.42;

enum PPDialogTone { primary, destructive }

Future<T?> showPPDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  final barrierLabel = MaterialLocalizations.of(
    context,
  ).modalBarrierDismissLabel;

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: Colors.black.withValues(alpha: _kPPDialogBarrierOpacity),
    pageBuilder: (dialogContext, _, _) {
      return SafeArea(
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _kPPDialogHorizontalInset,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _kPPDialogMaxWidth),
                child: builder(dialogContext),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder:
        (
          BuildContext _,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          final scale = Tween<double>(begin: 0.94, end: 1).animate(curved);

          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(scale: scale, child: child),
          );
        },
  );
}

Future<bool> showPPConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required IconData icon,
  PPDialogTone tone = PPDialogTone.primary,
  String cancelLabel = '取消',
  bool barrierDismissible = true,
}) async {
  final confirmed = await showPPDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext dialogContext) {
      return PPConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        icon: icon,
        tone: tone,
      );
    },
  );

  return confirmed ?? false;
}

class PPDialog extends StatelessWidget {
  final Widget? header;
  final Widget title;
  final Widget? content;
  final Widget actions;

  const PPDialog({
    super.key,
    this.header,
    required this.title,
    this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: _dialogDecoration(colorScheme),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (header != null) ...<Widget>[
              header!,
              const SizedBox(height: 20),
            ],
            title,
            if (content != null) ...<Widget>[
              const SizedBox(height: 12),
              content!,
            ],
            const SizedBox(height: 28),
            actions,
          ],
        ),
      ),
    );
  }

  BoxDecoration _dialogDecoration(ColorScheme colorScheme) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(_kPPDialogRadius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color.alphaBlend(
            colorScheme.primary.withValues(alpha: 0.06),
            colorScheme.surface,
          ),
          colorScheme.surfaceContainerLow,
        ],
      ),
      border: Border.all(
        color: colorScheme.outlineVariant.withValues(
          alpha: _kPPDialogBorderOpacity,
        ),
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withValues(alpha: _kPPDialogShadowOpacity),
          blurRadius: 32,
          offset: const Offset(0, 18),
        ),
      ],
    );
  }
}

class PPConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final IconData icon;
  final PPDialogTone tone;

  const PPConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.icon,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = _PPDialogPalette.resolve(theme.colorScheme, tone);

    return PPDialog(
      header: _PPDialogHeader(icon: icon, palette: palette),
      title: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
      ),
      content: Text(
        message,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
      ),
      actions: _PPDialogActions(
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
        palette: palette,
        onCancel: () => Navigator.of(context).pop(false),
        onConfirm: () => Navigator.of(context).pop(true),
      ),
    );
  }
}

class _PPDialogHeader extends StatelessWidget {
  final IconData icon;
  final _PPDialogPalette palette;

  const _PPDialogHeader({required this.icon, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kPPDialogHeaderSize,
      height: _kPPDialogHeaderSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[palette.tint, palette.tintMuted],
        ),
      ),
      child: Icon(icon, size: 28, color: palette.iconColor),
    );
  }
}

class _PPDialogActions extends StatelessWidget {
  final String cancelLabel;
  final String confirmLabel;
  final _PPDialogPalette palette;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _PPDialogActions({
    required this.cancelLabel,
    required this.confirmLabel,
    required this.palette,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FilledButton.tonal(
            onPressed: onCancel,
            style: _cancelStyle(context),
            child: Text(cancelLabel),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: onConfirm,
            style: _confirmStyle(context),
            child: Text(confirmLabel),
          ),
        ),
      ],
    );
  }

  ButtonStyle _cancelStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(_kPPDialogActionHeight),
      backgroundColor: colorScheme.surfaceContainerHigh,
      foregroundColor: colorScheme.onSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    );
  }

  ButtonStyle _confirmStyle(BuildContext context) {
    return FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(_kPPDialogActionHeight),
      backgroundColor: palette.buttonColor,
      foregroundColor: palette.buttonTextColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    );
  }
}

class _PPDialogPalette {
  final Color tint;
  final Color tintMuted;
  final Color iconColor;
  final Color buttonColor;
  final Color buttonTextColor;

  const _PPDialogPalette({
    required this.tint,
    required this.tintMuted,
    required this.iconColor,
    required this.buttonColor,
    required this.buttonTextColor,
  });

  factory _PPDialogPalette.resolve(ColorScheme colorScheme, PPDialogTone tone) {
    if (tone == PPDialogTone.destructive) {
      return _PPDialogPalette(
        tint: colorScheme.errorContainer,
        tintMuted: Color.alphaBlend(
          colorScheme.error.withValues(alpha: 0.14),
          colorScheme.surface,
        ),
        iconColor: colorScheme.onErrorContainer,
        buttonColor: colorScheme.error,
        buttonTextColor: colorScheme.onError,
      );
    }

    return _PPDialogPalette(
      tint: colorScheme.primaryContainer,
      tintMuted: Color.alphaBlend(
        colorScheme.primary.withValues(alpha: 0.14),
        colorScheme.surface,
      ),
      iconColor: colorScheme.onPrimaryContainer,
      buttonColor: colorScheme.primary,
      buttonTextColor: colorScheme.onPrimary,
    );
  }
}
