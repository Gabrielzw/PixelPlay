import 'package:flutter/material.dart';

import '../../../shared/domain/media_source_kind.dart';
import '../../player_core/domain/player_queue_item.dart';
import '../../player_core/presentation/player_page.dart';

const String kNetworkVideoDialogTitle = '\u64ad\u653e\u7f51\u7edc\u89c6\u9891';
const String kNetworkVideoFieldLabel = '\u7f51\u7edc\u89c6\u9891\u5730\u5740';
const String kNetworkVideoFieldHint =
    '\u8bf7\u8f93\u5165\u53ef\u76f4\u63a5\u64ad\u653e\u7684\u89c6\u9891 URL';
const String kNetworkVideoEmptyUrlMessage =
    '\u8bf7\u8f93\u5165\u7f51\u7edc\u89c6\u9891\u5730\u5740\u3002';
const String kNetworkVideoInvalidUrlMessage =
    '\u8bf7\u8f93\u5165\u6709\u6548\u7684\u7f51\u7edc\u89c6\u9891 URL\u3002';
const String kNetworkVideoDefaultTitle = '\u7f51\u7edc\u89c6\u9891';
const String kNetworkVideoDefaultSourceLabel =
    '\u5176\u4ed6 / \u7f51\u7edc\u94fe\u63a5';

const Set<String> kSupportedNetworkVideoSchemes = <String>{
  'http',
  'https',
  'rtsp',
  'rtmp',
  'mms',
  'ftp',
  'ftps',
};

Future<void> showNetworkVideoUrlDialogAndPlay({
  required BuildContext context,
}) async {
  final rawUrl = await showDialog<String>(
    context: context,
    builder: (BuildContext context) => const _NetworkVideoUrlDialog(),
  );
  if (rawUrl == null || !context.mounted) {
    return;
  }

  final item = buildNetworkVideoPlayerItem(rawUrl);
  await Navigator.of(context, rootNavigator: true).push(
    buildPlayerPageRoute(child: PlayerPage(playlist: <PlayerQueueItem>[item])),
  );
}

PlayerQueueItem buildNetworkVideoPlayerItem(String rawUrl) {
  final uri = parseNetworkVideoUri(rawUrl);
  final normalizedUrl = uri.toString();

  return PlayerQueueItem(
    id: normalizedUrl,
    title: _resolveNetworkVideoTitle(uri),
    sourceLabel: _resolveNetworkVideoSourceLabel(uri),
    sourceUri: normalizedUrl,
    sourceKind: MediaSourceKind.other,
  );
}

Uri parseNetworkVideoUri(String rawUrl) {
  final trimmedValue = rawUrl.trim();
  if (trimmedValue.isEmpty) {
    throw const FormatException(kNetworkVideoEmptyUrlMessage);
  }

  final uri = Uri.tryParse(trimmedValue);
  final scheme = uri?.scheme.toLowerCase();
  final isSupportedScheme =
      scheme != null &&
      kSupportedNetworkVideoSchemes.contains(scheme) &&
      trimmedValue.contains('://');
  if (uri == null || !uri.isAbsolute || !isSupportedScheme) {
    throw const FormatException(kNetworkVideoInvalidUrlMessage);
  }
  return uri;
}

String _resolveNetworkVideoTitle(Uri uri) {
  for (final segment in uri.pathSegments.reversed) {
    final trimmedSegment = segment.trim();
    if (trimmedSegment.isNotEmpty) {
      return trimmedSegment;
    }
  }
  if (uri.host.isNotEmpty) {
    return uri.host;
  }
  return kNetworkVideoDefaultTitle;
}

String _resolveNetworkVideoSourceLabel(Uri uri) {
  if (uri.host.isEmpty) {
    return kNetworkVideoDefaultSourceLabel;
  }
  return '\u5176\u4ed6 / ${uri.host}';
}

class _NetworkVideoUrlDialog extends StatefulWidget {
  const _NetworkVideoUrlDialog();

  @override
  State<_NetworkVideoUrlDialog> createState() => _NetworkVideoUrlDialogState();
}

class _NetworkVideoUrlDialogState extends State<_NetworkVideoUrlDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(kNetworkVideoDialogTitle),
      content: SizedBox(
        width: 420,
        child: TextField(
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.go,
          decoration: InputDecoration(
            labelText: kNetworkVideoFieldLabel,
            hintText: kNetworkVideoFieldHint,
            errorText: _errorText,
          ),
          onSubmitted: (_) => _submit(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('\u53d6\u6d88'),
        ),
        FilledButton(onPressed: _submit, child: const Text('\u64ad\u653e')),
      ],
    );
  }

  void _submit() {
    try {
      final uri = parseNetworkVideoUri(_controller.text);
      Navigator.of(context).pop(uri.toString());
    } on FormatException catch (error) {
      setState(() {
        _errorText = error.message;
      });
    }
  }
}
