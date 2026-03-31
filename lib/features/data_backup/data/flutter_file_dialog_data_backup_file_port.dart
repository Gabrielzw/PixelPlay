import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';

import '../domain/data_backup_file_port.dart';

const List<String> _kBackupMimeTypes = <String>[
  'application/json',
  'text/plain',
];
const List<String> _kBackupExtensions = <String>['json'];

class FlutterFileDialogDataBackupFilePort implements DataBackupFilePort {
  const FlutterFileDialogDataBackupFilePort();

  @override
  Future<String?> saveBackupFile({
    required String suggestedFileName,
    required String content,
  }) {
    final bytes = Uint8List.fromList(utf8.encode(content));
    return FlutterFileDialog.saveFile(
      params: SaveFileDialogParams(
        data: bytes,
        fileName: suggestedFileName,
        mimeTypesFilter: _kBackupMimeTypes,
      ),
    );
  }

  @override
  Future<String?> pickBackupFile() {
    return FlutterFileDialog.pickFile(
      params: const OpenFileDialogParams(
        fileExtensionsFilter: _kBackupExtensions,
        mimeTypesFilter: _kBackupMimeTypes,
        copyFileToCacheDir: true,
      ),
    );
  }
}
