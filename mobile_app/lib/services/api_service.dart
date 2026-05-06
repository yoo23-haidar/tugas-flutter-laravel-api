import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'auth_service.dart'; 

class ApiService { 
  static const String baseUrl = "http://127.0.0.1:8000/api"; 

  static Future<Map<String, String>> headers() async { 
    String? token = await AuthService.getToken(); 
    return { 
      "Authorization": "Bearer $token", 
      "Accept": "application/json", 
    }; 
  } 

  static Future post(String endpoint, Map data) async { 
    final response = await http.post( 
      Uri.parse("$baseUrl/$endpoint"), 
      body: data, 
    ); 
    return jsonDecode(response.body); 
  } 

  static Future get(String endpoint) async { 
    final response = await http.get( 
      Uri.parse("$baseUrl/$endpoint"), 
      headers: await headers(), 
    ); 
    return jsonDecode(response.body); 
  } 

  static Future delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$endpoint"),
      headers: await headers(),
    );
    return jsonDecode(response.body);
  }
}
