import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String apiEndPoint = 'https://6e52-62-112-9-244.ngrok-free.app/api/endpoint';

  Future<dynamic> getData() async {
    final response = await http.get(Uri.parse(apiEndPoint));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
