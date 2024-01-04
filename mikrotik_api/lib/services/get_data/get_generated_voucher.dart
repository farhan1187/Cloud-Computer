import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
Future<List<dynamic>> get_generated_voucher(
  String dns,
  int port,
  String username,
  String password,
) async {
  final username0 = username; // Replace with your MikroTik RouterOS username
  final password0 = password; // Replace with your MikroTik RouterOS password
  final basicAuth =
      'Basic ${base64Encode(utf8.encode('$username0:$password0'))}';

  var url = 'http://$dns:$port/rest/ip/hotspot/user';

  final uri = Uri.parse(url);

  try {
    final response = await http.get(uri, headers: {
      'Authorization': basicAuth,
    });

    if (response.statusCode == 200) {
      final body = response.body;
      final jsonData = jsonDecode(body) as List<dynamic>;
      final last500 = jsonData.length > 500
          ? jsonData.sublist(jsonData.length - 500)
          : jsonData;

      return last500.toList();
    } else {
      //  print('Failed to fetch MikroTik data: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    // print('Error fetching data: $e');
    return []; // Return an empty list in case of an error
  }
}
