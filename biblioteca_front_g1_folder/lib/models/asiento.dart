// lib/models/asiento.dart
class Asiento {
  final int id;
  final int seccionId;
  bool estaReservado;
  bool confirmado;
  DateTime? tiempoReserva;

  Asiento({
    required this.id,
    required this.seccionId,
    this.estaReservado = false,
    this.confirmado = false,
    this.tiempoReserva,
  });

  factory Asiento.fromJson(Map<String, dynamic> json) {
    return Asiento(
      id: json['id'],
      seccionId: json['seccion_id'],
      estaReservado: json['estaReservado'] == 1,
      confirmado: json['confirmado'] == 1,
    );
  }
}
