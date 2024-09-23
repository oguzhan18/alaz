import 'package:flutter_test/flutter_test.dart';
import 'package:alaz/src/form_data.dart';
import 'package:http/http.dart' as http;

void main() {
  group('AlazFormData Tests', () {
    test('Add field to form data', () {
      final formData = AlazFormData();
      formData.addField('name', 'test');

      expect(formData.fields['name'], 'test');
    });

    test('Add file to form data', () {
      final formData = AlazFormData();
      final file = http.MultipartFile.fromString('file', 'file content');

      formData.addFile('file', file);
      expect(formData.files['file'], isNotNull);
    });

    test('Convert form data to map', () {
      final formData = AlazFormData();
      formData.addField('name', 'test');
      final file = http.MultipartFile.fromString('file', 'file content');
      formData.addFile('file', file);

      final formDataMap = formData.toMap();
      expect(formDataMap['name'], 'test');
      expect(formDataMap['file'], isNotNull);
    });
  });
}
