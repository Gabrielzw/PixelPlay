import 'package:flutter/material.dart';

const double kSettingsHorizontalPadding = 24;
const double kSettingsBottomPadding = 40;
const double kSettingsSectionSpacing = 36;
const double kSettingsTileRadius = 28;
const double kSettingsMenuIconSize = 26;
const double kSettingsMenuIconContainerSize = 56;
const double kSettingsOverviewTitleSize = 30;
const double kSettingsDetailTitleSize = 18;
const double kSettingsSectionTitleSize = 14;

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

    return Scaffold(
      body: ColoredBox(
        color: theme.scaffoldBackgroundColor,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  kSettingsHorizontalPadding,
                  28,
                  kSettingsHorizontalPadding,
                  30,
                ),
                color: _settingsHeaderColor(theme),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: kSettingsOverviewTitleSize,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 28),
                    searchBar,
                  ],
                ),
              ),
              Expanded(child: child),
            ],
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: kSettingsDetailTitleSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: child,
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
