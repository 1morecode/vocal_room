import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vocal/res/api_data.dart';

class SocketController {
  static IO.Socket socket = IO.io(APIData.serverUrl, <String, dynamic>{
    'transports': ['websocket'],
  });
}
