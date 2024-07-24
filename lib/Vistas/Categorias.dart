import 'package:flutter/material.dart';
import 'package:prueba_mobile_developer/API/ApiServices.dart';
import 'package:prueba_mobile_developer/Modelos/Categoria.dart';
import 'package:prueba_mobile_developer/Vistas/Categoria.dart';

class Categorias extends StatefulWidget {
  @override
  _CategoriasState createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  late Future<List<Categoria>> _categoriasFuture;

  @override
  void initState() {
    super.initState();
    _categoriasFuture = _loadCategorias();
  }

  Future<List<Categoria>> _loadCategorias() async {
    return await ApiService().fetchAllCategorias();
  }

  void _refreshCategorias() {
    setState(() {
      _categoriasFuture = _loadCategorias();
    });
  }

  Future<void> _deleteCategoria(String clave) async {
    try {
      await ApiService().deleteCategoria(clave);
      _refreshCategorias();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar categoría')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: FutureBuilder<List<Categoria>>(
            future: _categoriasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(child: Text('No hay categorías disponibles'));
              } else {
                final categorias = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var categoria in categorias)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Clave: ${categoria.clave}',
                              style: TextStyle(fontSize: 18)),
                          Text('Nombre: ${categoria.nombre}',
                              style: TextStyle(fontSize: 18)),
                          Text(
                              'Fecha Creado: ${DateTime.fromMillisecondsSinceEpoch(categoria.fechaCreado)}',
                              style: TextStyle(fontSize: 18)),
                          Text('Activo: ${categoria.activo}',
                              style: TextStyle(fontSize: 18)),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CategoriaForm(categoria: categoria),
                                    ),
                                  );
                                  if (result == true) {
                                    _refreshCategorias();
                                  }
                                },
                                child: Text('Editar'),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () =>
                                    _deleteCategoria(categoria.clave),
                                child: Text('Eliminar'),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                  ],
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoriaForm(),
            ),
          ).then((result) {
            if (result == true) {
              _refreshCategorias();
            }
          });
        },
      ),
    );
  }
}
