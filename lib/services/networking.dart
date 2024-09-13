import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  Future<dynamic> getData(Uri url) async {
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;

    if (statusCode != 200) {
      print(statusCode);
      return Future.error(Exception('Unable to get weather data at this time'));
    }

    return jsonDecode(response.body);
  }
}
