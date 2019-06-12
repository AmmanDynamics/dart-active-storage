library active_storage;

import 'dart:io';

import 'package:meta/meta.dart';

import 'src/direct_upload.dart';
import 'src/uploader.dart';

export 'src/direct_upload.dart';

class ActiveStorage {
  static Future<DirectUploadResponse> upload({
    @required String fileName,
    @required String fileMimeType,
    @required File file,
    @required String directUploadURL,
    ProgressCallback onProgress,
  }) async {
    final uploader = Uploader(directUploadURL);
    int fileSize = await file.length();
    DirectUploadResponse response = await uploader.directUpload(
      DirectUploadRequest(
        fileName: fileName,
        contentType: fileMimeType,
        byteSize: fileSize,
        fileContents: file.openRead(),
      ),
    );
    await uploader.fileUpload(
      fileContents: file.openRead(),
      directUploadResponse: response,
      onProgress: onProgress,
    );
    return Future.value(response);
  }
}