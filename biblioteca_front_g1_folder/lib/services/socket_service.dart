// lib/services/socket_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  bool _isInitialized = false;

  void initSocket() {
    if (_isInitialized) return;
    
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      print('Conexión establecida');
      _isInitialized = true;
    });

    socket.onDisconnect((_) {
      print('Desconexión');
      _isInitialized = false;
    });

    socket.connect();
  }

  bool get isConnected => _isInitialized && socket.connected;

  void emit(String event, dynamic data) {
    if (isConnected) {
      socket.emit(event, data);
    } else {
      print('Socket no está conectado. No se puede emitir el evento: $event');
    }
  }

  void dispose() {
    if (_isInitialized) {
      socket.disconnect();
      _isInitialized = false;
    }
  }
}
