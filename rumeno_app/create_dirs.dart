import 'dart:io';

void main() {
  final dir = Directory(r'd:\Projects\InHouseWebsites\MobileApp\Rumeno\rumeno_app\lib\l10n\translations');
  dir.createSync(recursive: true);
  print('Directory created: ${dir.path}');
  print('Exists: ${dir.existsSync()}');
}
