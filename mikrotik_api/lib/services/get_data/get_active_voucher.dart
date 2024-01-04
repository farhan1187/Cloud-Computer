import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
Future<List<dynamic>> get_active_voucher(
  String dns,
  int port,
  String username,
  String password,
) async {
  final username0 = username; // Replace with your MikroTik RouterOS username
  final password0 = password; // Replace with your MikroTik RouterOS password
  final basicAuth =
      'Basic ${base64Encode(utf8.encode('$username0:$password0'))}';

  var url = 'http://$dns:$port/rest/ip/hotspot/active';

  final uri = Uri.parse(url);

  final response = await http.get(uri, headers: {
    'Authorization': basicAuth,
  });

  if (response.statusCode == 200) {
    final body = response.body;
    final jsonData = jsonDecode(body);
    return jsonData;
  } else {
    // print('Failed to fetch MikroTik data: ${response.statusCode}');
    return [];
  }
}
