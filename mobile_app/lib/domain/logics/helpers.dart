import 'dart:io';

class Helpers {
  static String getStoragePath(String uid, File file) {
    final name = file.path.split('/').last;
    return 'avatars/$uid/$name';
  }
}
