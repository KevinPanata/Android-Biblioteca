import 'package:flutter/material.dart';
import '../models/asiento.dart';
import 'asiento_widget.dart';

class GridAsientos extends StatelessWidget {
  final List<Asiento> asientos;
  final Function(Asiento) onAsientoSeleccionado;

  const GridAsientos({
    Key? key,
    required this.asientos,
    required this.onAsientoSeleccionado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: asientos.length,
      itemBuilder: (context, index) {
        return AsientoWidget(
          asiento: asientos[index],
          onTap: () => onAsientoSeleccionado(asientos[index]),
        );
      },
    );
  }
}
