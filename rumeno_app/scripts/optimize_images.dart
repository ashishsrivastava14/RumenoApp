import 'dart:io';
import 'package:image/image.dart' as img;

void main() async {
  final imagesDir = Directory('assets/images');
  final files = await imagesDir.list(recursive: true).toList();
  
  for (var entity in files) {
    if (entity is File && 
        (entity.path.endsWith('.png') || entity.path.endsWith('.jpg') || entity.path.endsWith('.jpeg'))) {
      print('Optimizing: ${entity.path}');
      
      try {
        final bytes = await entity.readAsBytes();
        final image = img.decodeImage(bytes);
        
        if (image != null) {
          // Resize large images and compress
          img.Image optimized = image;
          
          // If image is larger than 1920px, resize it
          if (image.width > 1920 || image.height > 1920) {
            final aspectRatio = image.width / image.height;
            if (aspectRatio > 1) {
              optimized = img.copyResize(image, width: 1920);
            } else {
              optimized = img.copyResize(image, height: 1920);
            }
          }
          
          // Encode with compression
          List<int> compressed;
          String newPath;
          
          if (entity.path.endsWith('.png')) {
            compressed = img.encodePng(optimized, level: 9);
            newPath = entity.path.replaceAll('.png', '_optimized.png');
          } else {
            compressed = img.encodeJpg(optimized, quality: 85);
            newPath = entity.path.replaceAll(RegExp(r'\.(jpg|jpeg)$'), '_optimized.jpg');
          }
          
          await File(newPath).writeAsBytes(compressed);
          
          final originalSize = bytes.length / 1024 / 1024;
          final newSize = compressed.length / 1024 / 1024;
          final savings = ((originalSize - newSize) / originalSize * 100).toStringAsFixed(1);
          
          print('  ✓ ${originalSize.toStringAsFixed(2)}MB → ${newSize.toStringAsFixed(2)}MB ($savings% savings)');
          print('  Created: $newPath');
        }
      } catch (e) {
        print('  ✗ Error: $e');
      }
    }
  }
  
  print('\n✅ Image optimization complete!');
  print('⚠️  Replace original files with _optimized versions after testing');
  print('⚠️  This will reduce image sizes by resizing large images and better compression');
}
