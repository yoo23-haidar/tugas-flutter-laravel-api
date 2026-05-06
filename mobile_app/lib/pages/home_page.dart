import 'package:flutter/material.dart'; 
import '../services/auth_service.dart'; 
import '../models/user_model.dart'; 

class HomePage extends StatefulWidget { 
  @override 
  _HomePageState createState() => _HomePageState(); 
} 

class _HomePageState extends State<HomePage> { 
  User? user; 

  @override 
  void initState() { 
    super.initState(); 
    loadUser(); 
  } 

  void loadUser() async { 
    // Load from local storage first to be fast
    User? localUser = await AuthService.getLocalUser();
    if (localUser != null && mounted) {
      setState(() { user = localUser; });
    }
    
    // Also fetch fresh from API
    User? fetchedUser = await AuthService.getUser(); 
    if (fetchedUser != null && mounted) {
      setState(() { user = fetchedUser; }); 
    }
  } 

  void logout(BuildContext context) async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          )
        ],
      ),
      body: Center( 
        child: user == null 
            ? CircularProgressIndicator() 
            : Card(
                margin: EdgeInsets.all(16.0),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Halo, ${user!.name}!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Text("Email: ${user!.email}", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text("NPM: ${user!.npm ?? '-'}", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ), 
      ), 
    ); 
  } 
}
