import 'categoria.dart';
import 'precio.dart';

class Articulo {
  final String clave;
  final Categoria categoria;
  final String nombre;
  final List<Precio> precios;
  final bool activo;

  Articulo({
    required this.clave,
    required this.categoria,
    required this.nombre,
    required this.precios,
    this.activo = true,
  });

  factory Articulo.fromJson(Map<String, dynamic> json) {
    return Articulo(
      clave: json['clave'],
      categoria: Categoria.fromJson(json['categoria']),
      nombre: json['nombre'],
      precios: (json['precios'] as List)
          .map((item) => Precio.fromJson(item))
          .toList(),
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clave': clave,
      'categoria': categoria.toJson(),
      'nombre': nombre,
      'precios': precios.map((precio) => precio.toJson()).toList(),
      'activo': activo,
    };
  }
}
