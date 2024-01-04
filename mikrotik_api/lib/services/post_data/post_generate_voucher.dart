import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';

String generateUniqueVoucher() {
  var uuid = const Uuid();
  return uuid.v4().substring(0, 8);
}

// ignore: non_constant_identifier_names
Future<void> post_generate_voucher(
  String comment,
  String dns,
  int port,
  String username,
  String password,
  String numberOfDays,
  String hotspot,
  String rateLimit,
  int totalVouchers,
) async {
  final String routerIP = '$dns:$port';
  const String endpoint = '/rest/ip/hotspot/user/add';
  final String combinedCredentials =
      base64.encode(utf8.encode('$username:$password'));

  const int batchSize = 50;
  final int batches = (totalVouchers / batchSize).ceil();

  for (int i = 0; i < batches; i++) {
    final int startIndex = i * batchSize;
    final int endIndex = (startIndex + batchSize < totalVouchers)
        ? startIndex + batchSize
        : totalVouchers;

    final List<Future<http.Response>> requests = List.generate(
      endIndex - startIndex,
      (_) {
        String voucher = generateUniqueVoucher();
        final Uri url = Uri.http(routerIP, endpoint);

        return http.post(
          url,
          headers: {
            'Authorization': 'Basic $combinedCredentials',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "comment": comment,
            "name": voucher,
            'password': voucher,
            "limit-uptime": "$numberOfDays d",
            "profile": rateLimit,
            "server": hotspot,
          }),
        );
      },
    );

    await _sendRequestsConcurrently(requests);

    // Wait for 1 second before sending the next batch
    if (i < batches - 1) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  // print('All requests completed successfully!');
}

Future<void> _sendRequestsConcurrently(
    List<Future<http.Response>> requests) async {
  const int concurrentLimit = 10; // Set the maximum concurrent requests limit
  final int totalRequests = requests.length;
  int completedRequests = 0;

  while (completedRequests < totalRequests) {
    final currentBatch = requests
        .skip(completedRequests)
        .take(concurrentLimit)
        .toList(growable: false);

    final responses = await Future.wait(currentBatch);

    for (var response in responses) {
      if (response.statusCode == 200) {
        //  print('Voucher generated successfully: ${response.body}');
        // Handle successful response
      } else {
        //  print('Failed to generate voucher: ${response.statusCode}');
        // Handle failure here for individual requests
      }
    }

    completedRequests += currentBatch.length;
  }
}
