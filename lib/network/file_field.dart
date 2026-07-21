
import 'dart:io';

class FileField {
  final String fieldName;
  final List<File> files;

  FileField({required this.fieldName, this.files = const []});
}