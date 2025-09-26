// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Publicidad {
  final int id;
  final String titulo;
  final String descripcion;
  final String imagen;
  final int estado;
  final String fechaRegistro;

  Publicidad({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.imagen,
    required this.estado,
    required this.fechaRegistro,
  });

  factory Publicidad.fromJson(Map<String, dynamic> json) {
    return Publicidad(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? 'Sin título',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      imagen: json['imagen'] ?? '',
      estado: json['estado'] ?? 0,
      fechaRegistro: json['fecha_registro'] ?? '0000-00-00 00:00:00',
    );
  }
}

class ApiService {
  static const String baseUrl = 'https://api-radioquishkambalito.unaux.com';
  static const String publicidadEndpoint = '/Api/publicidad.php';

  // Usar un proxy CORS confiable
  static const String corsProxy = 'https://api.allorigins.win/raw?url=';

  static Future<List<Publicidad>> fetchPublicidades() async {
    try {
      // Codificar la URL para el proxy
      final encodedUrl = Uri.encodeFull('$baseUrl$publicidadEndpoint');
      final proxyUrl = '$corsProxy$encodedUrl';

      print('🔄 Conectando a través de proxy: $proxyUrl');

      final response = await http.get(
        Uri.parse(proxyUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        // Verificar que la respuesta sea JSON válido
        final responseBody = response.body.trim();

        if (responseBody.startsWith('[') || responseBody.startsWith('{')) {
          final decodedResponse = json.decode(responseBody);

          if (decodedResponse is List) {
            print('✅ ${decodedResponse.length} publicidades cargadas');
            return decodedResponse.map((json) => Publicidad.fromJson(json)).toList();
          } else {
            throw Exception('Formato de respuesta inválido: Se esperaba un array');
          }
        } else {
          throw Exception('Respuesta no es JSON: $responseBody');
        }
      } else {
        throw Exception('Error HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en fetchPublicidades: $e');
      throw Exception('Error al cargar publicidades: $e');
    }
  }

  static String getImageUrl(String imagePath) {
    if (imagePath.isEmpty) return '';

    // Para imágenes también usar proxy si es necesario
    String cleanPath = imagePath.startsWith('/')
        ? imagePath.substring(1)
        : imagePath;

    return '$baseUrl/$cleanPath';
  }
}