import 'package:flutter/material.dart';

class CitasPage extends StatefulWidget {
  @override
  _CitasPageState createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _motivoController = TextEditingController();

  // Método para guardar la cita
  void _guardarCita() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aquí puedes enviar los datos al backend o hacer lo que necesites con ellos
      print("Cita guardada: ${_fechaController.text}, ${_horaController.text}, ${_motivoController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda de Citas'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _fechaController,
                decoration: InputDecoration(labelText: 'Fecha'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _horaController,
                decoration: InputDecoration(labelText: 'Hora'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la hora';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _motivoController,
                decoration: InputDecoration(labelText: 'Motivo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el motivo';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _guardarCita,
                child: Text('Guardar Cita'),
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