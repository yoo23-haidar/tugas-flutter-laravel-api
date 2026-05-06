import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../models/user_model.dart'; 
import 'api_service.dart'; 

class AuthService { 
  static Future<bool> login(String email, String password) async { 
    final data = await ApiService.post("login", { 
      "email": email, 
      "password": password, 
    }); 
    if (data['token'] != null) { 
      SharedPreferences prefs = await SharedPreferences.getInstance(); 
      await prefs.setString("token", data['token']); 
      if (data['user'] != null) {
        await prefs.setString("user", jsonEncode(data['user']));
      }
      return true; 
    } 
    return false; 
  } 

  static Future<bool> register(String name, String email, String password, String npm) async { 
    final data = await ApiService.post("register", { 
      "name": name, 
      "email": email, 
      "password": password, 
      "npm": npm,
    }); 
    return data != null && data['message'] == 'Register berhasil'; 
  } 

  static Future<String?> getToken() async { 
    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    return prefs.getString("token"); 
  } 

  static Future<User?> getLocalUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userStr = prefs.getString("user");
    if (userStr != null) {
      return User.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  static Future<User?> getUser() async { 
    final data = await ApiService.get("me"); 
    if (data != null && data['email'] != null) {
      final user = User.fromJson(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user", jsonEncode(user.toJson()));
      return user;
    }
    return null;
  } 

  static Future logout() async { 
    await ApiService.delete("logout");
    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    await prefs.clear(); 
  } 
}
