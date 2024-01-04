import 'dart:convert';
import 'package:http/http.dart' as http;

Future<int> fetchARPListWithCount(
  String dns,
  int port,
  String username,
  String password,
) async {
  final username0 = username; // Replace with your MikroTik RouterOS username
  final password0 = password; // Replace with your MikroTik RouterOS password
  final String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username0:$password0'))}';

  var url = 'http://$dns:$port/rest/ip/arp';

  final response = await http.get(
    Uri.parse(url),
    headers: {'authorization': basicAuth},
  );

  if (response.statusCode == 200) {
    // Successfully fetched data
    List<dynamic> arpList = json.decode(response.body);

    return arpList.length;
  } else {
    // Failed to fetch data
    throw Exception('Failed to load device information');
  }
}
