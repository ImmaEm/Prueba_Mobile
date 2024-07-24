import 'package:flutter/material.dart';
import 'package:prueba_mobile_developer/API/ApiServices.dart';
import 'package:prueba_mobile_developer/Modelos/Articulo.dart';
import 'package:prueba_mobile_developer/Modelos/Categoria.dart';
import 'package:prueba_mobile_developer/Vistas/Articulo.dart';

class Articulos extends StatefulWidget {
  @override
  _ArticulosState createState() => _ArticulosState();
}

class _ArticulosState extends State<Articulos> {
  late Future<List<Articulo>> _articulosFuture;
  late Future<List<Categoria>> _categoriasFuture;
  Map<int, Categoria> _categoriaMap = {};

  @override
  void initState() {
    super.initState();
    _articulosFuture = _loadArticulos();
    _categoriasFuture = _loadCategorias();
  }

  Future<List<Categoria>> _loadCategorias() async {
    List<Categoria> categorias = await ApiService().fetchAllCategorias();
    _categoriaMap = {for (var categoria in categorias) categoria.id: categoria};
    return categorias;
  }

  Future<List<Articulo>> _loadArticulos() async {
    return await ApiService().fetchAllArticulos();
  }

  void _refreshArticulos() {
    setState(() {
      _articulosFuture = _loadArticulos();
    });
  }

  Future<void> _deleteArticulo(int id) async {
    try {
      await ApiService().deleteArticulo(id);
      _refreshArticulos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el articulo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articulos'),
      ),
      body: FutureBuilder<List<Categoria>>(
        future: _categoriasFuture,
        builder: (context, categoriasSnapshot) {
          if (categoriasSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (categoriasSnapshot.hasError) {
            return Center(child: Text('Error: ${categoriasSnapshot.error}'));
          } else if (categoriasSnapshot.data == null ||
              categoriasSnapshot.data!.isEmpty) {
            return Center(child: Text('No hay categorías disponibles'));
          }

          return FutureBuilder<List<Articulo>>(
            future: _articulosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(child: Text('No hay articulos disponibles'));
              } else {
                final articulos = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var articulo in articulos)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Clave: ${articulo.clave}',
                              style: TextStyle(fontSize: 18)),
                          Text('Nombre: ${articulo.nombre}',
                              style: TextStyle(fontSize: 18)),
                          Text(
                              'Categoría: ${_categoriaMap[articulo.categoriaId]?.nombre ?? 'Desconocida'}',
                              style: TextStyle(fontSize: 18)),
                          Text('Activo: ${articulo.activo}',
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
                                          ArticuloForm(articulo: articulo),
                                    ),
                                  );
                                  if (result == true) {
                                    _refreshArticulos();
                                  }
                                },
                                child: Text('Editar'),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () => _deleteArticulo(articulo.id),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticuloForm(),
            ),
          ).then((result) {
            if (result == true) {
              _refreshArticulos();
            }
          });
        },
      ),
    );
  }
}
