import 'package:flutter/material.dart';
import 'package:prueba_mobile_developer/API/ApiServices.dart';
import 'package:prueba_mobile_developer/Modelos/Articulo.dart';
import 'package:prueba_mobile_developer/Modelos/Categoria.dart';

class ArticuloForm extends StatefulWidget {
  final Articulo? articulo;

  ArticuloForm({this.articulo});

  @override
  _ArticuloFormState createState() => _ArticuloFormState();
}

class _ArticuloFormState extends State<ArticuloForm> {
  final _formKey = GlobalKey<FormState>();
  late int _id;
  late String _clave;
  late String _nombre;
  late bool _activo;
  String? _selectedCategoria;
  List<Categoria> _categorias = [];

  @override
  void initState() {
    super.initState();
    if (widget.articulo != null) {
      _id = widget.articulo!.id;
      _clave = widget.articulo!.clave;
      _selectedCategoria = widget.articulo!.categoria;
      _nombre = widget.articulo!.nombre;
      _activo = widget.articulo!.activo;
    } else {
      _id = 0;
      _clave = '';
      _selectedCategoria = null;
      _nombre = '';
      _activo = true;
    }
    _fetchCategorias();
  }

  Future<void> _fetchCategorias() async {
    try {
      List<Categoria> categorias = await ApiService().fetchAllCategorias();
      setState(() {
        _categorias = categorias;
      });
    } catch (e) {
      // Manejar el error si ocurre
      print('Error al cargar categorías: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.articulo == null ? 'Crear Articulo' : 'Editar Articulo'),
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
              DropdownButtonFormField<String>(
                value: _selectedCategoria,
                items: _categorias.map((categoria) {
                  return DropdownMenuItem<String>(
                    value: categoria.nombre,
                    child: Text(categoria.nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoria = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Categoría'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione una categoría';
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
                    // Verifica si _selectedCategoria es null
                    if (_selectedCategoria == null ||
                        _selectedCategoria!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Por favor seleccione una categoría')),
                      );
                      return;
                    }

                    final articulo = Articulo(
                      id: _id,
                      clave: _clave,
                      categoria: _selectedCategoria!,
                      nombre: _nombre,
                      activo: _activo,
                    );

                    try {
                      if (widget.articulo == null) {
                        await ApiService().createArticulo(articulo);
                      } else {
                        await ApiService()
                            .updateArticulo(widget.articulo!.id, articulo);
                      }

                      Navigator.pop(
                          context, true); // Pasar un valor para indicar éxito
                    } catch (e) {
                      print('Error al crear o actualizar el artículo: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Error al registrar el artículo')),
                      );
                    }
                  }
                },
                child: Text(widget.articulo == null ? 'Crear' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
