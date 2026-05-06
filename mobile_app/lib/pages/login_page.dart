import 'package:flutter/material.dart'; 
import '../services/auth_service.dart'; 

class LoginPage extends StatefulWidget { 
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController(); 
  final password = TextEditingController(); 
  bool isLoading = false;

  void login() async { 
    if (_formKey.currentState!.validate()) {
      setState(() { isLoading = true; });
      bool success = await AuthService.login(email.text, password.text); 
      setState(() { isLoading = false; });
      
      if (success) { 
        Navigator.pushReplacementNamed(context, '/home'); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login gagal. Email atau password salah.")),
        );
      }
    }
  } 

  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(title: Text("Login")), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              TextFormField(
                controller: email, 
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email wajib diisi';
                  if (!value.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ), 
              SizedBox(height: 16),
              TextFormField(
                controller: password, 
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Password wajib diisi';
                  return null;
                },
              ), 
              SizedBox(height: 24),
              isLoading 
                ? CircularProgressIndicator() 
                : ElevatedButton(
                    onPressed: login, 
                    child: Text("Login"),
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                  ), 
              TextButton( 
                onPressed: () => Navigator.pushNamed(context, '/register'), 
                child: Text("Register"), 
              ) 
            ], 
          ),
        ), 
      ), 
    ); 
  } 
}
