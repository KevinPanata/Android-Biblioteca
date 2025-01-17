// lib/widgets/contador_regresivo.dart
import 'dart:async';
import 'package:flutter/material.dart';

class ContadorRegresivo extends StatefulWidget {
  final DateTime tiempoInicio;
  final VoidCallback onTimeExpired;

  const ContadorRegresivo({
    Key? key,
    required this.tiempoInicio,
    required this.onTimeExpired,
  }) : super(key: key);

  @override
  _ContadorRegresivoState createState() => _ContadorRegresivoState();
}

class _ContadorRegresivoState extends State<ContadorRegresivo> {
  Timer? _timer;
  String _tiempoRestante = '';

  @override
  void initState() {
    super.initState();
    _iniciarContador();
  }

  void _iniciarContador() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final ahora = DateTime.now();
      final tiempoLimite = widget.tiempoInicio.add(Duration(minutes: 5));
      final diferencia = tiempoLimite.difference(ahora);

      if (diferencia.isNegative) {
        _timer?.cancel();
        widget.onTimeExpired();
        return;
      }

      setState(() {
        _tiempoRestante = _formatearTiempo(diferencia);
      });
    });
  }

  String _formatearTiempo(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _tiempoRestante,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
