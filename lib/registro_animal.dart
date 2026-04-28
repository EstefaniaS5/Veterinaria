import 'package:flutter/material.dart';
import 'api_service.dart'; // Asegúrate de que este archivo esté importado

class RegistroAnimalPage extends StatefulWidget {
  @override
  _RegistroAnimalPageState createState() => _RegistroAnimalPageState();
}

class _RegistroAnimalPageState extends State<RegistroAnimalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _especieController = TextEditingController();
  final TextEditingController _razaController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _estadoSaludController = TextEditingController();
  String _sexo = 'macho'; // Valor predeterminado

  final ApiService apiService = ApiService();

  // Método para guardar el registro
  void _guardarRegistro() async {
    if (_formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> datosAnimal = {
        'nombre': _nombreController.text,
        'especie': _especieController.text,
        'raza': _razaController.text,
        'edad': _edadController.text,
        'estado_salud': _estadoSaludController.text,
        'sexo': _sexo,
      };

      try {
        final response = await apiService.registrarAnimal(datosAnimal);
        print('Datos guardados: ${response}');
        // Si el registro fue exitoso, haz algo (por ejemplo, redirige al usuario)
      } catch (e) {
        print('Error al guardar el registro: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Mascota'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Campos del formulario como antes...
              ElevatedButton(
                onPressed: _guardarRegistro,
                child: Text('Guardar Registro'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/inicio');
                },
                child: Text('Volver al Inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}