import 'dart:io';

void main() async {
  final sourceDir = Directory('c:/dev/Fit_App/fish');
  final destDir = Directory('c:/dev/Fit_App/assets/fish');

  if (!await destDir.exists()) {
    await destDir.create(recursive: true);
  }

  await for (final entity in sourceDir.list()) {
    if (entity is File && entity.path.endsWith('.png')) {
      final fileName = entity.uri.pathSegments.last;
      final newPath = '${destDir.path}/$fileName';
      await entity.copy(newPath);
      print('Copied $fileName');
    }
  }
}
