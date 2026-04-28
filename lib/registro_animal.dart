import 'package:flutter/material.dart';

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

  // Método para guardar el registro
  void _guardarRegistro() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aquí enviaríamos la data al backend o base de datos
      print("Datos guardados: ${_nombreController.text}, ${_especieController.text}");
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
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _especieController,
                decoration: InputDecoration(labelText: 'Especie'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la especie';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _razaController,
                decoration: InputDecoration(labelText: 'Raza'),
              ),
              TextFormField(
                controller: _edadController,
                decoration: InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _estadoSaludController,
                decoration: InputDecoration(labelText: 'Estado de salud'),
              ),
              Row(
                children: <Widget>[
                  Text('Sexo:'),
                  Radio<String>(
                    value: 'macho',
                    groupValue: _sexo,
                    onChanged: (String? value) {
                      setState(() {
                        _sexo = value!;
                      });
                    },
                  ),
                  Text('Macho'),
                  Radio<String>(
                    value: 'hembra',
                    groupValue: _sexo,
                    onChanged: (String? value) {
                      setState(() {
                        _sexo = value!;
                      });
                    },
                  ),
                  Text('Hembra'),
                ],
              ),
              ElevatedButton(
                onPressed: _guardarRegistro,
                child: Text('Guardar Registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}