// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/seccion.dart';
import '../models/asiento.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  Future<List<Seccion>> getSecciones() async {
    final response = await http.get(Uri.parse('$baseUrl/secciones'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Seccion.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener secciones');
    }
  }

  Future<List<Asiento>> getAsientosSeccion(int seccionId) async {
    final response = await http.get(Uri.parse('$baseUrl/asientos/$seccionId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Asiento.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener asientos');
    }
  }

  Future<void> reservarAsiento(int asientoId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/asientos/$asientoId/reservar'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Error al reservar asiento');
    }
  }

  Future<void> confirmarReserva(int asientoId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/asientos/$asientoId/confirmar'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Error al confirmar reserva');
    }
  }

  Future<void> cancelarReserva(int asientoId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/asientos/$asientoId/cancelar'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Error al cancelar reserva');
    }
  }
}
