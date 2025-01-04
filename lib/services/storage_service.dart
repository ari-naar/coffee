import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'base_service.dart';

class StorageService extends BaseService {
  // Singleton instance
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Upload a file
  Future<String> uploadFile({
    required String filePath,
    required File file,
    String? contentType,
    Map<String, String>? metadata,
  }) async {
    try {
      final ref = storage.ref(filePath);
      final settableMetadata = SettableMetadata(
        contentType: contentType,
        customMetadata: metadata,
      );

      await ref.putFile(file, settableMetadata);
      final downloadUrl = await ref.getDownloadURL();

      logInfo('File uploaded successfully: $filePath');
      return downloadUrl;
    } catch (e) {
      logError('Failed to upload file', e);
      rethrow;
    }
  }

  // Upload user profile image
  Future<String> uploadProfileImage(String uid, File imageFile) async {
    final extension = path.extension(imageFile.path);
    final filePath = 'users/$uid/profile$extension';

    return uploadFile(
      filePath: filePath,
      file: imageFile,
      contentType: 'image/jpeg',
      metadata: {'uploadedBy': uid},
    );
  }

  // Upload coffee image
  Future<String> uploadCoffeeImage(
      String uid, String coffeeId, File imageFile) async {
    final extension = path.extension(imageFile.path);
    final filePath = 'users/$uid/coffee/$coffeeId$extension';

    return uploadFile(
      filePath: filePath,
      file: imageFile,
      contentType: 'image/jpeg',
      metadata: {
        'uploadedBy': uid,
        'coffeeId': coffeeId,
      },
    );
  }

  // Delete a file
  Future<void> deleteFile(String filePath) async {
    try {
      final ref = storage.ref(filePath);
      await ref.delete();
      logInfo('File deleted successfully: $filePath');
    } catch (e) {
      logError('Failed to delete file', e);
      rethrow;
    }
  }

  // Get file metadata
  Future<Map<String, String>?> getFileMetadata(String filePath) async {
    try {
      final ref = storage.ref(filePath);
      final metadata = await ref.getMetadata();
      return metadata.customMetadata;
    } catch (e) {
      logError('Failed to get file metadata', e);
      rethrow;
    }
  }

  // Update file metadata
  Future<void> updateFileMetadata(
    String filePath,
    Map<String, String> metadata,
  ) async {
    try {
      final ref = storage.ref(filePath);
      final newMetadata = SettableMetadata(customMetadata: metadata);
      await ref.updateMetadata(newMetadata);
      logInfo('File metadata updated: $filePath');
    } catch (e) {
      logError('Failed to update file metadata', e);
      rethrow;
    }
  }

  // Get download URL
  Future<String> getDownloadURL(String filePath) async {
    try {
      final ref = storage.ref(filePath);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      logError('Failed to get download URL', e);
      rethrow;
    }
  }

  // List files in a directory
  Future<List<Reference>> listFiles(String path) async {
    try {
      final ref = storage.ref(path);
      final result = await ref.listAll();
      return result.items;
    } catch (e) {
      logError('Failed to list files', e);
      rethrow;
    }
  }

  // Copy file
  Future<void> copyFile(String sourcePath, String destinationPath) async {
    try {
      final sourceRef = storage.ref(sourcePath);
      final destinationRef = storage.ref(destinationPath);

      final bytes = await sourceRef.getData();
      if (bytes == null) throw Exception('Source file is empty');

      await destinationRef.putData(bytes);
      logInfo('File copied from $sourcePath to $destinationPath');
    } catch (e) {
      logError('Failed to copy file', e);
      rethrow;
    }
  }

  // Move file
  Future<void> moveFile(String sourcePath, String destinationPath) async {
    try {
      await copyFile(sourcePath, destinationPath);
      await deleteFile(sourcePath);
      logInfo('File moved from $sourcePath to $destinationPath');
    } catch (e) {
      logError('Failed to move file', e);
      rethrow;
    }
  }
}
