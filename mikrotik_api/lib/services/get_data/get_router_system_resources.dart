import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:mikrotik_api/services/selectedatamodel.dart';

class RouterSystemResourceService {
  late IOWebSocketChannel _webSocketChannel;
  late Stream<dynamic> _systemResourceStream;

  Stream<dynamic> get systemResourceDataStream => _systemResourceStream;

  RouterSystemResourceService(
    SelectedDataModel selectedData,
  ) {
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('${selectedData.selectedUsername}:${selectedData.selectedPassword}'))}';

    final url =
        'ws://${selectedData.selectedDns}:${selectedData.selectedPort}/rest/system/resource'; // WebSocket URL

    _webSocketChannel = IOWebSocketChannel.connect(
      Uri.parse(url),
      headers: {'Authorization': basicAuth},
    );

    _systemResourceStream = _webSocketChannel.stream.asBroadcastStream();
  }

  void closeConnection() {
    _webSocketChannel.sink.close();
  }
}
