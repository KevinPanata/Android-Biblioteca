// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/seccion.dart';
import '../providers/biblioteca_provider.dart';
import 'seccion_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BibliotecaProvider>().cargarSecciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biblioteca Pública'),
        centerTitle: true,
      ),
      body: Consumer<BibliotecaProvider>(
        builder: (context, provider, child) {
          if (provider.secciones.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando secciones...'),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: provider.secciones.length,
            itemBuilder: (context, index) {
              final seccion = provider.secciones[index];
              return SeccionCard(
                seccion: seccion,
                onTap: () {
                  provider.cargarAsientosSeccion(seccion.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeccionScreen(seccionId: seccion.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class SeccionCard extends StatelessWidget {
  final Seccion seccion;
  final VoidCallback onTap;

  const SeccionCard({
    Key? key,
    required this.seccion,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconForSeccion(seccion.nombre),
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 16),
              Text(
                seccion.nombre,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Sección ${seccion.id}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForSeccion(String nombre) {
    switch (nombre.toLowerCase()) {
      case 'infantil':
        return Icons.child_care;
      case 'juvenil':
        return Icons.school;
      case 'adultos':
        return Icons.person;
      case 'referencia':
        return Icons.book;
      default:
        return Icons.library_books;
    }
  }
}
