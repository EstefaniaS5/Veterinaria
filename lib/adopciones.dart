import 'package:flutter/material.dart';

class AdopcionesPage extends StatefulWidget {
  @override
  _AdopcionesPageState createState() => _AdopcionesPageState();
}

class _AdopcionesPageState extends State<AdopcionesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fechaAdopcionController = TextEditingController();
  String _estadoAdopcion = 'En proceso'; // Valor predeterminado

  // Método para guardar la adopción
  void _guardarAdopcion() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aquí puedes enviar los datos al backend o hacer lo que necesites con ellos
      print("Adopción registrada: ${_fechaAdopcionController.text}, Estado: $_estadoAdopcion");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Adopción'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _fechaAdopcionController,
                decoration: InputDecoration(labelText: 'Fecha de Adopción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha de adopción';
                  }
                  return null;
                },
              ),
              Row(
                children: <Widget>[
                  Text('Estado de adopción:'),
                  Radio<String>(
                    value: 'En proceso',
                    groupValue: _estadoAdopcion,
                    onChanged: (String? value) {
                      setState(() {
                        _estadoAdopcion = value!;
                      });
                    },
                  ),
                  Text('En proceso'),
                  Radio<String>(
                    value: 'Aprobada',
                    groupValue: _estadoAdopcion,
                    onChanged: (String? value) {
                      setState(() {
                        _estadoAdopcion = value!;
                      });
                    },
                  ),
                  Text('Aprobada'),
                ],
              ),
              ElevatedButton(
                onPressed: _guardarAdopcion,
                child: Text('Guardar Adopción'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}   