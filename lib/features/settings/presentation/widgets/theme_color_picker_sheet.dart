import 'package:flutter/material.dart';

const double kColorPreviewHeight = 108;
const double kColorSliderMax = 255;

class ThemeColorPickerSheet extends StatefulWidget {
  final Color initialColor;
  final List<Color> presetColors;

  const ThemeColorPickerSheet({
    super.key,
    required this.initialColor,
    this.presetColors = const <Color>[],
  });

  @override
  State<ThemeColorPickerSheet> createState() => _ThemeColorPickerSheetState();
}

class _ThemeColorPickerSheetState extends State<ThemeColorPickerSheet> {
  late double _red;
  late double _green;
  late double _blue;

  @override
  void initState() {
    super.initState();
    _red = widget.initialColor.r.toDouble();
    _green = widget.initialColor.g.toDouble();
    _blue = widget.initialColor.b.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final color = Color.fromARGB(
      255,
      _red.round(),
      _green.round(),
      _blue.round(),
    );
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset + 16),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '自定义主色',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 17),
              ),
              if (widget.presetColors.isNotEmpty) ...<Widget>[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: widget.presetColors
                      .map((Color presetColor) {
                        final isSelected = presetColor == color;

                        return InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => _applyColor(presetColor),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: presetColor,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      })
                      .toList(growable: false),
                ),
              ],
              const SizedBox(height: 18),
              Container(
                height: kColorPreviewHeight,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Text(
                    _toHex(color),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _ColorSlider(
                label: 'R',
                activeColor: Colors.red,
                value: _red,
                onChanged: (double next) => setState(() => _red = next),
              ),
              _ColorSlider(
                label: 'G',
                activeColor: Colors.green,
                value: _green,
                onChanged: (double next) => setState(() => _green = next),
              ),
              _ColorSlider(
                label: 'B',
                activeColor: Colors.blue,
                value: _blue,
                onChanged: (double next) => setState(() => _blue = next),
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('取消'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(color),
                      child: const Text('应用颜色'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _toHex(Color color) {
    final red = color.r.round().toRadixString(16).padLeft(2, '0');
    final green = color.g.round().toRadixString(16).padLeft(2, '0');
    final blue = color.b.round().toRadixString(16).padLeft(2, '0');
    return '#$red$green$blue'.toUpperCase();
  }

  void _applyColor(Color color) {
    setState(() {
      _red = color.r.toDouble();
      _green = color.g.toDouble();
      _blue = color.b.toDouble();
    });
  }
}

class _ColorSlider extends StatelessWidget {
  final String label;
  final Color activeColor;
  final double value;
  final ValueChanged<double> onChanged;

  const _ColorSlider({
    required this.label,
    required this.activeColor,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$label  ${value.round()}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
        ),
        Slider(
          value: value,
          max: kColorSliderMax,
          activeColor: activeColor,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
