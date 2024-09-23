import 'package:http/http.dart';

class AlazFormData {
  final Map<String, dynamic> fields = {};
  final Map<String, dynamic> files = {};

  void addField(String key, dynamic value) {
    fields[key] = value;
  }

  void addFile(String key, MultipartFile file) {
    files[key] = file;
  }

  Map<String, dynamic> toMap() {
    return {
      ...fields,
      ...files,
    };
  }
}
