import 'package:prueba_mobile_developer/Modelos/Precio.dart';

class Articulo {
  final int id;
  final String clave;
  final int categoriaId;
  final String nombre;
  final List<Precio> precios;
  final bool activo;

  Articulo({
    required this.id,
    required this.clave,
    required this.categoriaId,
    required this.nombre,
    required this.precios,
    this.activo = true,
  });

  factory Articulo.fromJson(Map<String, dynamic> json) {
    var preciosList = json['precios'] as List;
    List<Precio> precios = preciosList.map((i) => Precio.fromJson(i)).toList();

    var categoriaData = json['categoria'];
    int categoriaId =
        categoriaData is Map ? categoriaData['id'] : categoriaData;

    return Articulo(
      id: json['id'],
      clave: json['clave'],
      categoriaId: categoriaId,
      nombre: json['nombre'],
      precios: precios,
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clave': clave,
      'categoria': {'id': categoriaId},
      'nombre': nombre,
      'precios': precios.map((e) => e.toJson()).toList(),
      'activo': activo,
    };
  }
}
