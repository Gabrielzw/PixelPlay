import 'package:flutter/material.dart';

const double kSettingsHorizontalPadding = 24;
const double kSettingsBottomPadding = 40;
const double kSettingsSectionSpacing = 36;
const double kSettingsTileRadius = 28;
const double kSettingsMenuIconSize = 22;
const double kSettingsMenuIconContainerSize = 48;
const double kSettingsOverviewTitleSize = 24;
const double kSettingsDetailTitleSize = 16;
const double kSettingsSectionTitleSize = 12;

const EdgeInsets kSettingsPagePadding = EdgeInsets.fromLTRB(
  kSettingsHorizontalPadding,
  24,
  kSettingsHorizontalPadding,
  kSettingsBottomPadding,
);

class SettingsOverviewScaffold extends StatelessWidget {
  final String title;
  final Widget searchBar;
  final Widget child;

  const SettingsOverviewScaffold({
    super.key,
    required this.title,
    required this.searchBar,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compactTheme = _buildCompactSettingsTheme(theme);

    return Theme(
      data: compactTheme,
      child: Scaffold(
        body: ColoredBox(
          color: compactTheme.scaffoldBackgroundColor,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    kSettingsHorizontalPadding,
                    24,
                    kSettingsHorizontalPadding,
                    24,
                  ),
                  color: _settingsHeaderColor(compactTheme),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: compactTheme.textTheme.headlineSmall?.copyWith(
                          fontSize: kSettingsOverviewTitleSize,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 22),
                      searchBar,
                    ],
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsDetailScaffold extends StatelessWidget {
  final String title;
  final Widget child;

  const SettingsDetailScaffold({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compactTheme = _buildCompactSettingsTheme(theme);

    return Theme(
      data: compactTheme,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            title,
            style: compactTheme.textTheme.titleMedium?.copyWith(
              fontSize: kSettingsDetailTitleSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: child,
      ),
    );
  }
}

class SettingsSectionTitle extends StatelessWidget {
  final String title;

  const SettingsSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontSize: kSettingsSectionTitleSize,
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

Color _settingsHeaderColor(ThemeData theme) {
  return Color.alphaBlend(
    theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
    theme.colorScheme.surface,
  );
}

ThemeData _buildCompactSettingsTheme(ThemeData theme) {
  final textTheme = theme.textTheme;

  return theme.copyWith(
    iconTheme: theme.iconTheme.copyWith(size: 20),
    appBarTheme: theme.appBarTheme.copyWith(
      toolbarHeight: 50,
      iconTheme:
          theme.appBarTheme.iconTheme?.copyWith(size: 22) ??
          const IconThemeData(size: 22),
      actionsIconTheme:
          theme.appBarTheme.actionsIconTheme?.copyWith(size: 22) ??
          const IconThemeData(size: 22),
    ),
    textTheme: textTheme.copyWith(
      titleLarge: textTheme.titleLarge?.copyWith(fontSize: 16),
      titleMedium: textTheme.titleMedium?.copyWith(fontSize: 14),
      bodyLarge: textTheme.bodyLarge?.copyWith(fontSize: 14),
      bodyMedium: textTheme.bodyMedium?.copyWith(fontSize: 13),
      bodySmall: textTheme.bodySmall?.copyWith(fontSize: 12),
      labelLarge: textTheme.labelLarge?.copyWith(fontSize: 13),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: textTheme.labelLarge?.copyWith(fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: textTheme.labelLarge?.copyWith(fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: textTheme.labelLarge?.copyWith(fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    ),
  );
}
