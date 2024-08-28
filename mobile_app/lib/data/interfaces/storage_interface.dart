import 'dart:io';

abstract interface class StorageRepository {
  Future<String> uploadFile(String storageFilePath, File file);
  Stream<double> uploadProgress(String storageFilePath);
  Future<void> deleteFile(String storageFilePath);
  Future<void> deleteByUrl(String url);
  Future<String> getDownloadUrl(String storageFilePath);
}
