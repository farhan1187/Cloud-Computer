import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
Future<bool> delete_Voucher(
  String voucherId,
  String dns,
  int port,
  String username,
  String password,
  String data,
) async {
  final username0 = username; // Replace with your MikroTik RouterOS username
  final password0 = password; // Replace with your MikroTik RouterOS password
  final basicAuth =
      'Basic ${base64Encode(utf8.encode('$username0:$password0'))}';

  var url =
      'http://$dns:$port/rest/ip/hotspot/$data/$voucherId'; // Modify the URL according to your MikroTik API

  final uri = Uri.parse(url);

  final response = await http.delete(uri, headers: {
    'Authorization': basicAuth,
  });

  if (response.statusCode == 200) {
    // print('Voucher deleted successfully');
    return true;
  } else {
    //  print('Failed to delete voucher: ${response.statusCode}');
    return false;
  }
}
