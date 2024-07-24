import 'package:flutter/material.dart';
import 'package:prueba_mobile_developer/API/ApiServices.dart';
import 'package:prueba_mobile_developer/Modelos/Categoria.dart';

class CategoriaForm extends StatefulWidget {
  final Categoria? categoria;

  CategoriaForm({this.categoria});

  @override
  _CategoriaFormState createState() => _CategoriaFormState();
}

class _CategoriaFormState extends State<CategoriaForm> {
  final _formKey = GlobalKey<FormState>();
  late String _clave;
  late String _nombre;
  late bool _activo;

  @override
  void initState() {
    super.initState();
    if (widget.categoria != null) {
      _clave = widget.categoria!.clave;
      _nombre = widget.categoria!.nombre;
      _activo = widget.categoria!.activo;
    } else {
      _clave = '';
      _nombre = '';
      _activo = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.categoria == null ? 'Crear Categoría' : 'Editar Categoría'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _clave,
                decoration: InputDecoration(labelText: 'Clave'),
                onChanged: (value) => _clave = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la clave';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _nombre,
                decoration: InputDecoration(labelText: 'Nombre'),
                onChanged: (value) => _nombre = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text('Activo'),
                value: _activo,
                onChanged: (value) {
                  setState(() {
                    _activo = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final categoria = Categoria(
                      clave: _clave,
                      fechaCreado: DateTime.now().millisecondsSinceEpoch,
                      nombre: _nombre,
                      activo: _activo,
                    );

                    if (widget.categoria == null) {
                      await ApiService().createCategoria(categoria);
                    } else {
                      await ApiService()
                          .updateCategoria(widget.categoria!.clave, categoria);
                    }

                    Navigator.pop(
                        context, true); // Pasar un valor para indicar éxito
                  }
                },
                child: Text(widget.categoria == null ? 'Crear' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
