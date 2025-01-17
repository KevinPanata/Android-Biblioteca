// lib/widgets/asiento_widget.dart
import 'package:flutter/material.dart';
import '../models/asiento.dart';
import 'contador_regresivo.dart';

class AsientoWidget extends StatelessWidget {
  final Asiento asiento;
  final VoidCallback onTap;
  final VoidCallback? onCancelar;
  final VoidCallback? onConfirmar;

  const AsientoWidget({
    Key? key,
    required this.asiento,
    required this.onTap,
    this.onCancelar,
    this.onConfirmar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color asientoColor = Colors.green;
    if (asiento.estaReservado) {
      asientoColor = asiento.confirmado ? Colors.red : Colors.orange;
    }

    return GestureDetector(
      onTap: asiento.estaReservado ? null : onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: asientoColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                asiento.id.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (asiento.estaReservado && !asiento.confirmado)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          if (asiento.estaReservado && !asiento.confirmado && asiento.tiempoReserva != null)
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Center(
                child: ContadorRegresivo(
                  tiempoInicio: asiento.tiempoReserva!,
                  onTimeExpired: onCancelar ?? () {},
                ),
              ),
            ),
          if (asiento.estaReservado && !asiento.confirmado)
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.white, size: 20),
                    onPressed: onConfirmar,
                    tooltip: 'Confirmar',
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: onCancelar,
                    tooltip: 'Cancelar',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
