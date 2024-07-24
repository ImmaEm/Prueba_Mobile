import 'package:flutter/material.dart';
import 'package:prueba_mobile_developer/API/ApiServices.dart';
import 'package:prueba_mobile_developer/Modelos/Articulo.dart';
import 'package:prueba_mobile_developer/Modelos/Categoria.dart';
import 'package:prueba_mobile_developer/Modelos/Precio.dart';

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
  int? _selectedCategoriaId;
  List<Categoria> _categorias = [];
  List<Precio> _precios = [];

  @override
  void initState() {
    super.initState();
    if (widget.articulo != null) {
      _id = widget.articulo!.id;
      _clave = widget.articulo!.clave;
      _selectedCategoriaId = widget.articulo!.categoriaId;
      _nombre = widget.articulo!.nombre;
      _precios = widget.articulo!.precios;
      _activo = widget.articulo!.activo;
    } else {
      _id = 0;
      _clave = '';
      _selectedCategoriaId = null;
      _nombre = '';
      _precios = [];
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
      print('Error al cargar categorías: $e');
    }
  }

  void _addPrecio() {
    setState(() {
      _precios.add(Precio(precio: 0.0));
    });
  }

  void _removePrecio(int index) {
    setState(() {
      _precios.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.articulo == null ? 'Crear Artículo' : 'Editar Artículo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                DropdownButtonFormField<int>(
                  value: _selectedCategoriaId,
                  hint: Text('Seleccionar Categoría'),
                  items: _categorias.map((categoria) {
                    return DropdownMenuItem<int>(
                      value: categoria.id,
                      child: Text(categoria.nombre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoriaId = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor seleccione una categoría';
                    }
                    return null;
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _precios.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _precios[index].precio.toString(),
                            decoration: InputDecoration(labelText: 'Precio'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                _precios[index] =
                                    Precio(precio: double.parse(value));
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese un precio';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _removePrecio(index),
                        ),
                      ],
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: _addPrecio,
                  child: Text('Agregar Precio'),
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
                      final articulo = Articulo(
                        id: _id,
                        clave: _clave,
                        categoriaId: _selectedCategoriaId!,
                        nombre: _nombre,
                        precios: _precios,
                        activo: _activo,
                      );

                      if (widget.articulo == null) {
                        await ApiService().createArticulo(articulo);
                      } else {
                        await ApiService()
                            .updateArticulo(widget.articulo!.id, articulo);
                      }

                      Navigator.pop(context, true);
                    }
                  },
                  child: Text(widget.articulo == null ? 'Crear' : 'Actualizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
