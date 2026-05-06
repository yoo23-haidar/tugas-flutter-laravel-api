import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'auth_service.dart'; 

class ApiService { 
  static const String baseUrl = "http://127.0.0.1:8000/api"; 

  static Map<String, String> baseHeaders() {
    return {
      "Accept": "application/json",
    };
  }

  static Future<Map<String, String>> authHeaders() async { 
    String? token = await AuthService.getToken(); 
    return { 
      "Authorization": "Bearer $token", 
      "Accept": "application/json", 
    }; 
  } 

  // For unauthenticated routes: login, register
  static Future post(String endpoint, Map data) async { 
    try {
      final response = await http.post( 
        Uri.parse("$baseUrl/$endpoint"), 
        body: data, 
        headers: baseHeaders(),
      ); 
      return jsonDecode(response.body);
    } catch (e) {
      print("API post error: $e");
      return null;
    }
  } 

  // For authenticated POST routes (e.g., creating notes)
  static Future authPost(String endpoint, Map data) async { 
    try {
      final response = await http.post( 
        Uri.parse("$baseUrl/$endpoint"), 
        body: data, 
        headers: await authHeaders(),
      ); 
      return jsonDecode(response.body);
    } catch (e) {
      print("API authPost error: $e");
      return null;
    }
  } 

  static Future get(String endpoint) async { 
    try {
      final response = await http.get( 
        Uri.parse("$baseUrl/$endpoint"), 
        headers: await authHeaders(), 
      ); 
      return jsonDecode(response.body);
    } catch (e) {
      print("API get error: $e");
      return null;
    }
  } 

  static Future delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/$endpoint"),
        headers: await authHeaders(),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("API delete error: $e");
      return null;
    }
  }

  static Future put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$endpoint"),
        body: body,
        headers: await authHeaders(),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("API put error: $e");
      return null;
    }
  }
}
