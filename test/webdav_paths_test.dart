import 'package:flutter_test/flutter_test.dart';
import 'package:pixelplay/features/webdav_client/domain/webdav_paths.dart';

void main() {
  test('normalizes webdav url path', () {
    final url = normalizeWebDavUrl('http://192.168.1.100:5244/dav/quark/');

    expect(url.toString(), 'http://192.168.1.100:5244/dav/quark');
  });

  test('converts absolute path to relative path under url directory', () {
    final path = resolveRelativeWebDavPath(
      baseUrl: Uri.parse('http://192.168.1.100:5244/dav/quark'),
      path: '/dav/quark/movies',
    );

    expect(path, '/movies');
  });

  test('maps same directory path to root slash', () {
    final path = resolveRelativeWebDavPath(
      baseUrl: Uri.parse('http://192.168.1.100:5244/dav/quark'),
      path: '/dav/quark',
    );

    expect(path, '/');
  });
}
