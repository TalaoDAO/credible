import 'package:json_path/json_path.dart';

List<String> getTextsFromCredential(
    String jsonPath, Map<String, dynamic> data) {
  final textList = <String>[];
  print('jsonPath: $jsonPath');
  try {
    final fieldsPath = JsonPath(jsonPath);
    fieldsPath.read(data).forEach((a) {
      print('one found: ${a.value}');
      if (a.value is String) {
        textList.add(a.value);
        print(a.value);
      }
      if (a.value is List) {
        for (final value in a.value) {
          if (value is String) {
            textList.add(value);
            print(value);
          }
        }
        print('inside: ${a.value}');

        print('gotcha?');
        // textList.addAll(a.value);
      }
    });
    return textList;
  } catch (e) {
    return textList;
  }
}
