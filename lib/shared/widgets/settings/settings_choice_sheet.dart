import 'package:flutter/material.dart';

@immutable
class SettingsChoiceOption<T> {
  final T value;
  final String title;
  final String? subtitle;
  final IconData? icon;

  const SettingsChoiceOption({
    required this.value,
    required this.title,
    this.subtitle,
    this.icon,
  });
}

Future<T?> showSettingsChoiceSheet<T>({
  required BuildContext context,
  required String title,
  String? description,
  required T selectedValue,
  required List<SettingsChoiceOption<T>> options,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      final theme = Theme.of(context);
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;
      final maxHeight = MediaQuery.sizeOf(context).height * 0.72;

      return Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset + 16),
        child: Material(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(32),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (description case final String value) ...<Widget>[
                        const SizedBox(height: 8),
                        Text(
                          value,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                    itemCount: options.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 2),
                    itemBuilder: (BuildContext context, int index) {
                      final option = options[index];
                      final selected = option.value == selectedValue;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () => Navigator.of(context).pop(option.value),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            child: Row(
                              children: <Widget>[
                                if (option.icon
                                    case final IconData icon) ...<Widget>[
                                  Icon(
                                    icon,
                                    size: 20,
                                    color: selected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 14),
                                ],
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        option.title,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              fontSize: 15,
                                              fontWeight: selected
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                            ),
                                      ),
                                      if (option.subtitle
                                          case final String value) ...<Widget>[
                                        const SizedBox(height: 4),
                                        Text(
                                          value,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                fontSize: 13,
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  selected
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_unchecked_rounded,
                                  size: 22,
                                  color: selected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outline,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
