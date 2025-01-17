class Seccion {
  final int id;
  final String nombre;

  Seccion({required this.id, required this.nombre});

  factory Seccion.fromJson(Map<String, dynamic> json) {
    return Seccion(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}
