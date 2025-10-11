import 'dart:core';

void main() {
  String originalString = "/home/user/documents/sample";
  print("Original string: $originalString");

  // Concatenation using StringBuffer
  String fileName = "file.txt";
  var sb = StringBuffer();
  sb.write(originalString);
  // ensure there's a separator (avoid double slash if originalString already ends with '/')
  if (!originalString.endsWith('/')) sb.write('/');
  sb.write(fileName);
  String filePath = sb.toString();
  print("File path: $filePath");

  // Substring extraction
  String fileParentDirName = originalString.substring(
    originalString.lastIndexOf('/') + 1,
  );
  print("File parent directory name: $fileParentDirName");

  // Changing case
  String upperCaseString = filePath.toUpperCase();
  print("File path (upper case): $upperCaseString");
}
