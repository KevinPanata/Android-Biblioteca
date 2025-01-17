// lib/providers/biblioteca_provider.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/seccion.dart';
import '../models/asiento.dart';
import '../services/api_service.dart';
import '../services/socket_service.dart';

class BibliotecaProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SocketService _socketService = SocketService();
  
  BibliotecaProvider() {
    _socketService.initSocket(); // Inicializa el socket al crear el provider
  }

  List<Seccion> _secciones = [];
  Map<int, List<Asiento>> _asientosPorSeccion = {};
  Map<int, Timer> _temporizadores = {};

  List<Seccion> get secciones => _secciones;

  // Inicializar el provider
  Future<void> init() async {
    await cargarSecciones();
    _configurarSocketListeners();
  }

  // Cargar secciones
  Future<void> cargarSecciones() async {
    try {
      _secciones = await _apiService.getSecciones();
      notifyListeners();
    } catch (e) {
      print('Error al cargar secciones: $e');
    }
  }

  // Obtener sección por ID
  Seccion? getSeccionById(int id) {
    try {
      return _secciones.firstWhere((seccion) => seccion.id == id);
    } catch (e) {
      return null;
    }
  }

  // Cargar asientos de una sección
  Future<void> cargarAsientosSeccion(int seccionId) async {
    try {
      final asientos = await _apiService.getAsientosSeccion(seccionId);
      _asientosPorSeccion[seccionId] = asientos;
      notifyListeners();
    } catch (e) {
      print('Error al cargar asientos: $e');
    }
  }

  // Obtener asientos de una sección
  List<Asiento> getAsientosSeccion(int seccionId) {
    return _asientosPorSeccion[seccionId] ?? [];
  }

  // Reservar asiento
  Future<void> reservarAsiento(Asiento asiento) async {
    try {
      await _apiService.reservarAsiento(asiento.id);
      
      asiento.estaReservado = true;
      asiento.tiempoReserva = DateTime.now();
      
      // Iniciar temporizador de 5 minutos
      _temporizadores[asiento.id]?.cancel();
      _temporizadores[asiento.id] = Timer(Duration(minutes: 5), () {
        cancelarReserva(asiento);
      });
      
      notifyListeners();
      
      _socketService.socket.emit('asiento-reservado', {
        'asientoId': asiento.id,
        'seccionId': asiento.seccionId,
      });
    } catch (e) {
      print('Error al reservar asiento: $e');
      throw e;
    }
  }

  // Confirmar reserva
  Future<void> confirmarReserva(Asiento asiento) async {
    try {
      await _apiService.confirmarReserva(asiento.id);
      
      asiento.confirmado = true;
      asiento.estaReservado = true;
      
      _temporizadores[asiento.id]?.cancel();
      _temporizadores.remove(asiento.id);
      
      notifyListeners();
      
      _socketService.emit('asiento-confirmado', {
        'asientoId': asiento.id,
        'seccionId': asiento.seccionId,
      });
    } catch (e) {
      print('Error al confirmar reserva: $e');
      throw e;
    }
  }

  // Cancelar reserva
  Future<void> cancelarReserva(Asiento asiento) async {
    try {
      await _apiService.cancelarReserva(asiento.id);
      
      asiento.estaReservado = false;
      asiento.confirmado = false;
      
      _temporizadores[asiento.id]?.cancel();
      _temporizadores.remove(asiento.id);
      
      notifyListeners();
      
      _socketService.emit('asiento-cancelado', {
        'asientoId': asiento.id,
        'seccionId': asiento.seccionId,
      });
    } catch (e) {
      print('Error al cancelar reserva: $e');
      throw e;
    }
  }

  void _configurarSocketListeners() {
    _socketService.socket.on('asiento-actualizado', (data) {
      final asientoId = data['asientoId'];
      final seccionId = data['seccionId'];
      final estado = data['estado'];
      
      final asientos = _asientosPorSeccion[seccionId];
      if (asientos != null) {
        final asiento = asientos.firstWhere((a) => a.id == asientoId);
        asiento.estaReservado = estado['estaReservado'];
        asiento.confirmado = estado['confirmado'];
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _socketService.dispose();
    super.dispose();
  }
}
