// lib/screens/seccion_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/biblioteca_provider.dart';
import '../widgets/asiento_widget.dart';

class SeccionScreen extends StatelessWidget {
  final int seccionId;

  const SeccionScreen({
    Key? key, 
    required this.seccionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BibliotecaProvider>(
      builder: (context, provider, child) {
        final asientos = provider.getAsientosSeccion(seccionId);
        final seccion = provider.getSeccionById(seccionId);

        return Scaffold(
          appBar: AppBar(
            title: Text(seccion?.nombre ?? 'Sección $seccionId'),
            centerTitle: true,
          ),
          body: asientos.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: asientos.length,
                  itemBuilder: (context, index) {
                    final asiento = asientos[index];
                    return AsientoWidget(
                      asiento: asiento,
                      onTap: () => provider.reservarAsiento(asiento),
                      onConfirmar: () async {
                        try {
                          await provider.confirmarReserva(asiento);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Reserva confirmada exitosamente')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al confirmar la reserva')),
                          );
                        }
                      },
                      onCancelar: () async {
                        try {
                          await provider.cancelarReserva(asiento);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Reserva cancelada exitosamente')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al cancelar la reserva')),
                          );
                        }
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
